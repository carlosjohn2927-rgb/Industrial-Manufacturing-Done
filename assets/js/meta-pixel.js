(function () {
    'use strict';
    var panel = document.getElementById('vp-meta-preferences');
    var manage = document.getElementById('vp-meta-manage');
    var configNode = document.getElementById('vp-meta-config');
    var config = configNode ? JSON.parse(configNode.textContent) : null;
    var started = false;
    function consent() {
        var match = document.cookie.match(/(?:^|;\s*)vp_meta_consent=(yes|no)(?:;|$)/);
        return match ? match[1] : '';
    }
    function start() {
        if (started || !config || location.hash || consent() !== 'yes') return;
        started = true;
        // Meta's official queue/loader, created only after opt-in.
        !function(f,b,e,v,n,t,s) {
            if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};
            if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];
            t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s);
        }(window, document, 'script', 'https://connect.facebook.net/en_US/fbevents.js');
        fbq('set', 'autoConfig', false, config.id);
        fbq('init', config.id);
        config.events.forEach(function (event) {
            if (event.id) fbq('track', event.name, event.data, {eventID: event.id});
            else fbq('track', event.name, event.data);
        });
    }
    // Track an actual search submission without transmitting its free-text query.
    // Query-bearing result pages never load the Pixel (see server partial).
    document.addEventListener('submit', function (e) {
        if (!started || consent() !== 'yes' || !config.searchEnabled || e.defaultPrevented) return;
        var form = e.target;
        if (!form || form.tagName !== 'FORM') return;
        var field = form.querySelector('[name="q"]');
        var url;
        try { url = new URL(form.action, location.href); } catch (_) { return; }
        if (field && field.value.trim() && url.origin === location.origin && config.searchPaths.indexOf(url.pathname) !== -1) {
            fbq('track', 'Search', {});
        }
    });
    if (!panel || !manage) return;
    if (!consent()) panel.hidden = false;
    manage.addEventListener('click', function () { panel.hidden = false; });
    panel.addEventListener('click', function (e) {
        var choice = e.target.getAttribute('data-meta-choice');
        if (choice !== 'yes' && choice !== 'no') return;
        var previous = consent();
        document.cookie = 'vp_meta_consent=' + choice + '; Path=/; Max-Age=15552000; SameSite=Lax' + (location.protocol === 'https:' ? '; Secure' : '');
        panel.hidden = true;
        // Reload on withdrawal to unload the third-party script immediately.
        if (choice === 'no') {
            // Remove the first-party Meta identifiers we can access. Other
            // domains and HttpOnly cookies remain outside this site's control.
            ['_fbp', '_fbc'].forEach(function (name) {
                document.cookie = name + '=; Path=/; Max-Age=0; SameSite=Lax';
                var labels = location.hostname.split('.');
                // Meta may set its cookies on a parent domain. Browsers reject
                // public-suffix domains, so try each applicable suffix.
                for (var i = 0; i < labels.length - 1; i++) {
                    document.cookie = name + '=; Path=/; Domain=' + labels.slice(i).join('.') + '; Max-Age=0; SameSite=Lax';
                }
            });
        }
        if (choice === 'no' && (previous === 'yes' || started)) location.reload();
        else if (choice === 'yes') start();
    });
    start();
}());
