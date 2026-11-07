// Browser-side consent and event queue tests; no Meta network requests.
const fs = require('fs'), vm = require('vm'), assert = require('assert');
const script = fs.readFileSync('assets/js/meta-pixel.js', 'utf8');
function page(initial, events, configured = true, options = {}) {
    let cookie = initial, inserted = [], reloads = 0, submit;
    const panel = {hidden: true, addEventListener: (type, cb) => panel.click = cb};
    const manage = {addEventListener: (type, cb) => manage.click = cb};
    const doc = {
        get cookie() { return cookie; },
        set cookie(value) { if (value.indexOf('vp_meta_consent=') === 0) cookie = value.split(';')[0]; },
        getElementById(id) { return id === 'vp-meta-preferences' ? panel : id === 'vp-meta-manage' ? manage : configured ? {textContent: JSON.stringify({id:'123456', events, searchEnabled:options.searchEnabled !== false, searchPaths:['/products','/search']})} : null; },
        addEventListener(type, cb) { if (type === 'submit') submit = cb; },
        createElement() { return {}; },
        getElementsByTagName() { return [{parentNode:{insertBefore(el) {inserted.push(el.src);}}}]; }
    };
    const context = {document:doc, URL, location:{protocol:'https:', origin:'https://example.test', href:'https://example.test/', hostname:'example.test', hash: options.hash || '', reload() {reloads++;}}};
    context.window = context;
    vm.runInNewContext(script, context);
    return {context, panel, manage, inserted, get reloads(){return reloads;}, search(value, action = 'https://example.test/products') { submit({defaultPrevented:false,target:{tagName:'FORM',action,querySelector(){return {value};}}}); }, choose(value) {panel.click({target:{getAttribute(){return value;}}});}};
}
const events = [{name:'PageView',data:{}}, {name:'ViewContent',data:{content_ids:['p1']}}, {name:'Search',data:{}}, {name:'Lead',data:{},id:'event123'}];
let p = page('', events);
assert.equal(p.panel.hidden, false); assert.equal(p.inserted.length, 0);
p.choose('no'); assert.equal(p.inserted.length, 0); assert.equal(p.panel.hidden, true);
p.manage.click(); p.choose('yes'); assert.equal(p.inserted.length, 1);
let q = Array.from(p.context.fbq.queue, args => Array.from(args));
assert.deepEqual(q.map(a => a[0]), ['set','init','track','track','track','track']);
assert.equal(q[5][3].eventID, 'event123');
p.manage.click(); p.choose('yes'); assert.equal(p.inserted.length, 1);
const beforeSearch = p.context.fbq.queue.length; p.search('valve'); assert.equal(p.context.fbq.queue.length, beforeSearch + 1); assert.equal(p.context.fbq.queue[beforeSearch][1], 'Search');
p.search('  '); p.search('valve', 'https://elsewhere.test/products'); assert.equal(p.context.fbq.queue.length, beforeSearch + 1);
p.manage.click(); p.choose('no'); assert.equal(p.reloads, 1);
p = page('vp_meta_consent=yes', [{name:'Contact',data:{},id:'xyz'}]);
assert.equal(p.inserted.length, 1); assert.equal(p.context.fbq.queue[2][3].eventID, 'xyz');
p = page('vp_meta_consent=no', events); assert.equal(p.inserted.length, 0); assert.equal(p.panel.hidden, true);
p = page('vp_meta_consent=yes', events, false); assert.equal(p.inserted.length, 0);
p = page('vp_meta_consent=yes', events, true, {hash:'#private'}); assert.equal(p.inserted.length, 0);
p = page('vp_meta_consent=yes', [], true, {searchEnabled:false});
const disabledSearchLength = p.context.fbq.queue.length; p.search('valve'); assert.equal(p.context.fbq.queue.length, disabledSearchLength);
console.log('Meta browser checks passed: opt-in/out, preferences, one loader, event queue and deduplication ID.');
