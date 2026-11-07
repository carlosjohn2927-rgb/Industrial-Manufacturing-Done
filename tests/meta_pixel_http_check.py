#!/usr/bin/env python3
"""Destructive end-to-end checks against a disposable local test site only.

Requires a running isolated PHP/SQLite app with a fake Pixel ID enabled, all
existing event switches on, no CAPI token, and an empty writable mail target.
The script submits test contact and RFQ records; never point it at production.
See tests/README.md. Uses only Python's standard library.
"""
import http.cookiejar
import json
import os
import re
import sqlite3
import sys
import urllib.error
import urllib.parse
import urllib.request
import uuid

base = os.environ.get('META_TEST_BASE_URL', '').rstrip('/')
db_path = os.environ.get('META_TEST_SQLITE_DB', '')
url = urllib.parse.urlsplit(base)
if (os.environ.get('META_TEST_ALLOW_WRITES') != '1' or url.scheme != 'http'
        or url.hostname not in ('localhost', '127.0.0.1') or not db_path):
    sys.exit('Set META_TEST_ALLOW_WRITES=1, META_TEST_BASE_URL=http://localhost:PORT and META_TEST_SQLITE_DB to a disposable SQLite database.')

class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None

jar = http.cookiejar.CookieJar()
client = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar), NoRedirect())
def request(path, fields=None):
    data = urllib.parse.urlencode(fields, doseq=True).encode() if fields is not None else None
    req = urllib.request.Request(urllib.parse.urljoin(base + '/', path.lstrip('/')), data=data)
    try:
        response = client.open(req, timeout=15)
    except urllib.error.HTTPError as exc:
        response = exc
    return response.code, response.headers, response.read().decode('utf-8', errors='replace')

def check(condition, label):
    if not condition:
        raise AssertionError(label)
    print('PASS:', label)

def config(html):
    found = re.search(r'<script type="application/json" id="vp-meta-config">(.*?)</script>', html, re.S)
    return json.loads(found.group(1)) if found else None

def names(html):
    return [item['name'] for item in (config(html) or {}).get('events', [])]

def csrf(html):
    match = re.search(r'name="csrf_token" value="([^"]+)"', html)
    if not match:
        raise AssertionError('CSRF token not found')
    return match.group(1)

def consent(value):
    # CookieJar canonicalizes localhost to localhost.local.
    domain = 'localhost.local' if url.hostname == 'localhost' else url.hostname
    jar.set_cookie(http.cookiejar.Cookie(version=0, name='vp_meta_consent', value=value,
        port=None, port_specified=False, domain=domain, domain_specified=False,
        domain_initial_dot=False, path='/', path_specified=True, secure=False,
        expires=None, discard=True, comment=None, comment_url=None, rest={}, rfc2109=False))

status, _, home = request('/')
check(status == 200 and home.count('id="vp-meta-config"') == 1 and home.count('meta-pixel.js') == 1, 'one config and local loader on homepage')
check('connect.facebook.net' not in home, 'Meta script is not embedded before consent')
status, _, page = request('/products?q=private')
check(status == 200 and config(page) is None, 'query page suppresses Pixel config')
status, _, page = request('/?fbclid=abcdefghijklmnop')
check(status == 200 and config(page) is not None, 'standalone Meta click ID permits Pixel config')
status, _, page = request('/?fbclid=abcdefghijklmnop&q=private')
check(status == 200 and config(page) is None, 'extra query parameters suppress Pixel config')
status, _, page = request('/login')
check(status == 200 and config(page) is None, 'login page suppresses Pixel config')
slug = os.environ.get('META_TEST_PRODUCT_SLUG', 'vortexpro-ball-valve-vp150')
status, _, page = request('/products/' + slug)
check(status == 200 and names(page).count('ViewContent') == 1, 'product page has one ViewContent')
product = next(item for item in config(page)['events'] if item['name'] == 'ViewContent')
check(product['data']['content_ids'] and product['data']['content_name'], 'product event has database identity')

email = 'meta-test-' + uuid.uuid4().hex + '@example.test'
consent('yes')
status, _, page = request('/contact')
fields = {'csrf_token': csrf(page), 'name': 'Test Visitor', 'email': email, 'subject': 'Test', 'message': 'This is a disposable test message.'}
invalid = dict(fields, message='short')
status, _, page = request('/contact/submit', invalid)
check(status == 200 and 'Contact' not in names(page), 'invalid contact does not create a conversion')
# CSRF rotates on POST; obtain the fresh value from a GET.
status, _, page = request('/contact')
fields['csrf_token'] = csrf(page)
status, headers, _ = request('/contact/submit', fields)
check(status in (301, 302, 303) and urllib.parse.urlsplit(headers.get('Location', '')).path.endswith('/contact'), 'valid contact redirects to success page')
status, _, page = request('/about')
check('Contact' not in names(page), 'unrelated page does not consume or display Contact')
status, _, page = request('/contact')
check(names(page).count('Contact') == 1 and bool(next(e for e in config(page)['events'] if e['name'] == 'Contact').get('id')), 'contact success has exactly one event with ID')
status, _, page = request('/contact')
check('Contact' not in names(page), 'contact refresh does not replay conversion')

status, _, page = request('/rfq')
fields = {'csrf_token': csrf(page), 'companyName': 'Test Company', 'contactPerson': 'Test Visitor',
          'email': email, 'country': 'CH', 'item_name[]': 'Valve', 'item_qty[]': '2'}
status, headers, _ = request('/rfq/submit', fields)
location = headers.get('Location', '')
check(status in (301, 302, 303) and '/rfq/thanks/' in location, 'valid RFQ redirects to success page')
status, _, page = request('/contact')
check('Lead' not in names(page), 'unrelated page does not consume or display Lead')
status, _, page = request(urllib.parse.urlsplit(location).path)
check(names(page).count('Lead') == 1 and bool(next(e for e in config(page)['events'] if e['name'] == 'Lead').get('id')), 'RFQ success has exactly one Lead with ID')
status, _, page = request(urllib.parse.urlsplit(location).path)
check('Lead' not in names(page), 'RFQ refresh does not replay conversion')
with sqlite3.connect(db_path) as db:
    contact_count = db.execute('SELECT COUNT(*) FROM contacts WHERE email = ?', (email,)).fetchone()[0]
    quote_count = db.execute('SELECT COUNT(*) FROM quotes WHERE email = ?', (email,)).fetchone()[0]
check(contact_count == 1 and quote_count == 1, 'successful actions correspond to stored contact and quote')

consent('no')
status, _, page = request('/contact')
fields = {'csrf_token': csrf(page), 'name': 'Test Visitor', 'email': email,
          'subject': 'No consent', 'message': 'This is another disposable test message.'}
status, _, _ = request('/contact/submit', fields)
check(status in (301, 302, 303), 'contact still works with consent rejected')
status, _, page = request('/contact')
check('Contact' not in names(page), 'rejected consent suppresses conversion')
print('Meta HTTP checks passed.')
