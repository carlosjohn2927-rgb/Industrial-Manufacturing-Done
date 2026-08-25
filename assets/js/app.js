// Vortex Precision - public site JS
(function () {
    'use strict';
    document.addEventListener('DOMContentLoaded', function () {
        var t = document.getElementById('vp-mobile-toggle');
        var m = document.getElementById('vp-mobile-menu');
        if (t && m) {
            t.addEventListener('click', function () { m.classList.toggle('hidden'); });
        }
        // Auto-dismiss flash messages after 6 seconds
        document.querySelectorAll('.container .bg-blue-50, .container .bg-green-50, .container .bg-red-50').forEach(function (el) {
            setTimeout(function () { el.style.opacity = '0'; el.style.transition = 'opacity .4s'; setTimeout(function(){ el.remove(); }, 500); }, 6000);
        });
    });
})();

// RFQ page: "+ Add line item" / per-row delete.
// External file - the production CSP blocks inline scripts.
(function () {
    'use strict';
    document.addEventListener('DOMContentLoaded', function () {
        var items = document.getElementById('vp-items');
        var addBtn = document.getElementById('vp-item-add');
        if (!items || !addBtn) return;

        addBtn.addEventListener('click', function () {
            var div = document.createElement('div');
            div.className = 'vp-item-row grid grid-cols-12 gap-2';
            div.innerHTML = '<input class="vp-input col-span-6" name="item_name[]" placeholder="Product or service" required>'
                + '<input class="vp-input col-span-2" name="item_qty[]" type="number" min="1" value="1" required>'
                + '<input class="vp-input col-span-3" name="item_spec[]" placeholder="Specifications">'
                + '<button type="button" class="vp-btn vp-btn-secondary col-span-1 vp-item-del" aria-label="Remove line">×</button>';
            items.appendChild(div);
        });
        items.addEventListener('click', function (e) {
            if (e.target.classList.contains('vp-item-del')) {
                if (items.querySelectorAll('.vp-item-row').length > 1) {
                    e.target.closest('.vp-item-row').remove();
                }
            }
        });
    });
})();

// ===================================================================
// Product search overlay — opens from the header search button,
// provides live AJAX suggestions as the user types, and submits
// to the full product catalog page on Enter.
// ===================================================================
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        var toggle   = document.getElementById('vp-search-toggle');
        var overlay  = document.getElementById('vp-search-overlay');
        var input    = document.getElementById('vp-search-input');
        var form     = document.getElementById('vp-search-form');
        var results  = document.getElementById('vp-search-results');
        if (!toggle || !overlay || !input || !results) return;

        var debounceTimer = null;
        var lastQuery     = '';
        var ajaxUrl       = (window.location.origin + '/search/ajax').replace(/([^:])\/\//g, '$1/');
        // Build the AJAX URL relative to the site base so it works under subfolders.
        var baseMeta = document.querySelector('meta[name="base-url"]');
        if (baseMeta) {
            ajaxUrl = baseMeta.getAttribute('content').replace(/\/$/, '') + '/search/ajax';
        } else {
            // Derive from the form action (e.g. http://host/products → http://host/search/ajax)
            var action = form.getAttribute('action') || '';
            var m = action.match(/^(https?:\/\/[^/]+)/i);
            if (m) ajaxUrl = m[1] + '/search/ajax';
        }

        function openSearch() {
            overlay.hidden = false;
            document.body.style.overflow = 'hidden';
            // Delay focus slightly so the animation starts first.
            setTimeout(function () { input.focus(); input.select(); }, 80);
        }

        function closeSearch() {
            overlay.hidden = true;
            document.body.style.overflow = '';
            input.value = '';
            results.innerHTML = '';
            lastQuery = '';
        }

        // Open button
        toggle.addEventListener('click', function (e) {
            e.preventDefault();
            openSearch();
        });

        // Close buttons (backdrop + X)
        overlay.querySelectorAll('[data-vp-search-close]').forEach(function (el) {
            el.addEventListener('click', closeSearch);
        });

        // Escape key to close
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && !overlay.hidden) {
                closeSearch();
            }
            // "/" shortcut to open (when not focused on an input)
            if (e.key === '/' && overlay.hidden) {
                var tag = (document.activeElement && document.activeElement.tagName) || '';
                if (tag !== 'INPUT' && tag !== 'TEXTAREA' && tag !== 'SELECT') {
                    e.preventDefault();
                    openSearch();
                }
            }
        });

        // Live search: debounce AJAX after the user stops typing
        input.addEventListener('input', function () {
            var q = input.value.trim();
            if (debounceTimer) clearTimeout(debounceTimer);

            if (q.length < 2) {
                results.innerHTML = '';
                lastQuery = '';
                return;
            }
            if (q === lastQuery) return;

            debounceTimer = setTimeout(function () {
                lastQuery = q;
                results.innerHTML = '<div class="vp-search-loading"><i class="ri-loader-4-line"></i> Searching…</div>';

                var xhr = new XMLHttpRequest();
                var url = ajaxUrl + '?q=' + encodeURIComponent(q);
                xhr.open('GET', url, true);
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState !== 4) return;
                    if (xhr.status !== 200) {
                        results.innerHTML = '';
                        return;
                    }
                    try {
                        var data = JSON.parse(xhr.responseText);
                        renderResults(data.results || [], data.q || q);
                    } catch (err) {
                        results.innerHTML = '';
                    }
                };
                xhr.send();
            }, 250);
        });

        function renderResults(items, q) {
            if (!items.length) {
                results.innerHTML = '<div class="vp-search-empty">No products found for "' + escapeHtml(q) + '". Press Enter to search the full catalog.</div>';
                return;
            }
            var html = '';
            items.forEach(function (item) {
                html += '<a href="' + escapeHtml(item.url) + '" class="vp-search-result-item">';
                if (item.image) {
                    html += '<img src="' + escapeHtml(item.image) + '" alt="" class="vp-search-result-img" loading="lazy">';
                } else {
                    html += '<div class="vp-search-result-img" style="display:flex;align-items:center;justify-content:center;color:#d1d5db;"><i class="ri-image-line text-2xl"></i></div>';
                }
                html += '<div class="vp-search-result-body">';
                if (item.sku) html += '<div class="vp-search-result-sku">' + escapeHtml(item.sku) + '</div>';
                html += '<div class="vp-search-result-name">' + escapeHtml(item.name) + '</div>';
                if (item.desc) html += '<div class="vp-search-result-desc">' + escapeHtml(item.desc) + '</div>';
                html += '</div>';
                html += '<i class="ri-arrow-right-s-line vp-search-result-arrow"></i>';
                html += '</a>';
            });
            results.innerHTML = html;
        }

        function escapeHtml(s) {
            return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        // If the page loads with ?q= in the URL (e.g. returning from search),
        // don't auto-open. But if someone lands here from a deep link wanting
        // search, they can press /.
    });
})();
