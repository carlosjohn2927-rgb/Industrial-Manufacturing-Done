// Vortex Precision - admin JS
(function () {
    'use strict';
    document.addEventListener('DOMContentLoaded', function () {
        // Previous / forward controls in the dashboard header. Keeping this in
        // the shared script (rather than inline onclick attributes) preserves
        // the production Content-Security-Policy.
        document.querySelectorAll('[data-vp-history]').forEach(function (button) {
            button.addEventListener('click', function () {
                if (button.getAttribute('data-vp-history') === 'forward') {
                    window.history.forward();
                } else {
                    window.history.back();
                }
            });
        });

        // Sidebar toggle (mobile)
        var t = document.getElementById('vp-admin-toggle');
        var sb = document.getElementById('vp-admin-sidebar') || document.querySelector('aside');
        if (t && sb) {
            t.addEventListener('click', function () { sb.classList.toggle('hidden'); sb.classList.toggle('fixed'); sb.classList.toggle('inset-y-0'); sb.classList.toggle('z-50'); });
        }

        // Init flatpickr on data-flatpickr elements
        if (window.flatpickr) {
            document.querySelectorAll('[data-flatpickr]').forEach(function (el) { flatpickr(el, { allowInput: true }); });
        }

        // Auto-dismiss flash
        document.querySelectorAll('main .bg-blue-50, main .bg-green-50, main .bg-red-50').forEach(function (el) {
            setTimeout(function () { el.style.opacity = '0'; el.style.transition = 'opacity .4s'; setTimeout(function(){ el.remove(); }, 500); }, 6000);
        });

        // Confirm delete forms
        document.querySelectorAll('form[data-confirm]').forEach(function (f) {
            f.addEventListener('submit', function (e) {
                if (!confirm(f.dataset.confirm || 'Are you sure?')) e.preventDefault();
            });
        });
        document.querySelectorAll('button[data-confirm]').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                if (!confirm(btn.getAttribute('data-confirm') || 'Are you sure?')) e.preventDefault();
            });
        });

        // Colour pickers (Appearance → Colours): keep hex field, native picker
        // and live CSS-variable preview in sync.
        function vpExpandHex(v) {
            v = String(v || '').trim();
            if (/^#[0-9a-fA-F]{3}$/.test(v)) {
                return ('#' + v[1] + v[1] + v[2] + v[2] + v[3] + v[3]).toLowerCase();
            }
            if (/^#[0-9a-fA-F]{6}$/.test(v)) return v.toLowerCase();
            return '';
        }
        document.querySelectorAll('[data-vp-color]').forEach(function (wrap) {
            var picker = wrap.querySelector('[data-vp-color-picker]');
            var text = wrap.querySelector('[data-vp-color-text]');
            if (!picker || !text) return;
            var apply = function (hex, fromPicker) {
                if (!hex) return;
                if (!fromPicker) picker.value = hex;
                text.value = hex;
                var name = (fromPicker ? picker : text).getAttribute('data-vp-theme-var');
                if (name) document.documentElement.style.setProperty(name, hex);
                var surface = document.querySelector('[data-vp-preview-surface]');
                var sidebar = document.querySelector('[data-vp-preview-sidebar]');
                if (name === '--vp-bg' && surface) surface.style.backgroundColor = hex;
                if (name === '--vp-writeup') {
                    document.querySelectorAll('[data-vp-preview-writeup]').forEach(function (el) {
                        el.style.color = hex;
                    });
                }
                if (name === '--vp-sidebar-bg' && sidebar) sidebar.style.backgroundColor = hex;
                if (name === '--vp-sidebar-writeup' && sidebar) sidebar.style.color = hex;
            };
            picker.addEventListener('input', function () { apply(picker.value, true); });
            text.addEventListener('input', function () { apply(vpExpandHex(text.value), false); });
            apply(vpExpandHex(text.value) || picker.value, true);
        });

        // Dashboard: quotes-by-status doughnut (data passed via data-quotes
        // so no inline script is needed - CSP blocks those in production).
        var chartEl = document.getElementById('vp-quotes-chart');
        if (chartEl && window.Chart) {
            var counts = {};
            try { counts = JSON.parse(chartEl.getAttribute('data-quotes') || '{}'); } catch (e) { counts = {}; }
            var labels = ['NEW', 'REVIEWING', 'QUOTED', 'APPROVED', 'REJECTED', 'COMPLETED'];
            var data = labels.map(function (l) { return counts[l] || 0; });
            new Chart(chartEl, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{ data: data, backgroundColor: ['#3b82f6', '#eab308', '#6366f1', '#10b981', '#ef4444', '#9ca3af'] }]
                },
                options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
            });
        }

        // Product form: live slug preview + specification rows.
        var slugInput = document.querySelector('input[name="slug"]');
        var slugPrev = document.getElementById('vp-slug-preview');
        if (slugInput && slugPrev) {
            slugInput.addEventListener('input', function () { slugPrev.textContent = slugInput.value || 'your-slug'; });
        }
        var specs = document.getElementById('vp-specs');
        var specAdd = document.getElementById('vp-spec-add');
        if (specs && specAdd) {
            specAdd.addEventListener('click', function () {
                var div = document.createElement('div');
                div.className = 'vp-spec-row grid grid-cols-12 gap-2';
                div.innerHTML = '<input class="vp-input col-span-4" name="spec_key[]" placeholder="Key">'
                    + '<input class="vp-input col-span-5" name="spec_value[]" placeholder="Value">'
                    + '<input class="vp-input col-span-2" name="spec_unit[]" placeholder="Unit">'
                    + '<button type="button" class="vp-btn vp-btn-secondary col-span-1 vp-spec-del" aria-label="Remove row">×</button>';
                specs.appendChild(div);
            });
            specs.addEventListener('click', function (e) {
                if (e.target.classList.contains('vp-spec-del')) {
                    e.target.closest('.vp-spec-row').remove();
                }
            });
        }
    
        /* ---------------- Dropdowns (notifications, profile) ------------- */
        document.addEventListener('click', function (e) {
            var toggle = e.target.closest('[data-vp-dropdown-toggle]');
            document.querySelectorAll('[data-vp-dropdown-menu]').forEach(function (m) {
                var wrap = m.closest('[data-vp-dropdown]');
                if (toggle && wrap && wrap.contains(toggle)) return;
                m.classList.add('hidden');
            });
            if (toggle) {
                e.preventDefault();
                var menu = toggle.closest('[data-vp-dropdown]').querySelector('[data-vp-dropdown-menu]');
                if (menu) menu.classList.toggle('hidden');
            }
        });

        /* ---------------- Copy to clipboard ------------------------------ */
        document.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-vp-copy]');
            if (!btn) return;
            e.preventDefault();
            var text = btn.getAttribute('data-vp-copy');
            var done = function () {
                var old = btn.innerHTML;
                btn.innerHTML = '<i class="ri-check-line"></i> Copied';
                setTimeout(function () { btn.innerHTML = old; }, 1500);
            };
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(text).then(done);
            } else {
                var ta = document.createElement('textarea');
                ta.value = text; document.body.appendChild(ta); ta.select();
                try { document.execCommand('copy'); done(); } catch (err) {}
                document.body.removeChild(ta);
            }
        });

        /* ---------------- Media picker ----------------------------------- */
        var modal = document.getElementById('vp-media-modal');
        var grid  = document.getElementById('vp-media-grid');
        var target = null;

        /**
         * Resolve the admin base URL at runtime instead of trusting the
         * configured VP_ADMIN_BASE blindly. If that value points at a
         * different origin than the page the admin is actually on (www vs
         * non-www, http vs https, a stale VP_BASE_URL), every media-library
         * request would go to the wrong host and hang or be blocked as
         * mixed content — leaving the picker stuck on "Loading…"/"Uploading…".
         */
        function vpAdminBase() {
            var b = String(window.VP_ADMIN_BASE || '').trim().replace(/\/+$/, '');
            var origin = window.location.origin
                || (window.location.protocol + '//' + window.location.host);
            if (!b) return origin + '/';
            try {
                var u = new URL(b, window.location.href);
                if (u.origin !== origin) {
                    // Keep the configured path (sub-folder installs) but use
                    // the origin the page is actually served from.
                    return origin + (u.pathname || '/').replace(/\/+$/, '') + '/';
                }
                return b + '/';
            } catch (e) {
                return origin + '/';
            }
        }

        /**
         * Keep every CSRF token on the page in sync with the server.
         * CI3 rotates the token on every POST (csrf_regenerate), so an AJAX
         * save (media upload, homepage reorder, …) invalidates the hidden
         * token of every form already rendered on the page — the next Save
         * is then rejected with a 403 and the category/product "never saves".
         * Whenever the server returns a fresh token we push it into the meta
         * tag AND every hidden form input.
         */
        function vpSyncCsrf(csrf) {
            if (!csrf) return;
            var meta = document.querySelector('meta[name="csrf-token"]');
            var name = meta && meta.getAttribute('data-name') ? meta.getAttribute('data-name') : 'csrf_token';
            if (meta) meta.setAttribute('content', csrf);
            document.querySelectorAll('input[type="hidden"][name="' + name + '"]').forEach(function (inp) {
                inp.value = csrf;
            });
        }

        function closeModal() { if (modal) modal.classList.add('hidden'); }

        function renderMedia(items) {
            if (!grid) return;
            if (!items.length) {
                grid.innerHTML = '<p class="col-span-full text-center text-sm text-gray-500 py-10">No files yet — upload one above.</p>';
                return;
            }
            grid.innerHTML = items.map(function (m) {
                var isImg = (m.mimeType || '').indexOf('image/') === 0;
                var thumb = isImg
                    ? '<img src="' + m.url + '" alt="" class="w-full h-24 object-cover">'
                    : '<div class="w-full h-24 flex items-center justify-center bg-gray-100 text-gray-500"><i class="ri-file-3-line text-3xl"></i></div>';
                return '<button type="button" class="border rounded-lg overflow-hidden hover:ring-2 hover:ring-blue-500 text-left" data-vp-media-pick="' + m.url + '">'
                     + thumb
                     + '<span class="block px-2 py-1 text-[11px] truncate">' + (m.originalName || m.filename) + '</span></button>';
            }).join('');
        }

        function loadMedia(q) {
            if (!grid) return;
            grid.innerHTML = '<p class="col-span-full text-center text-sm text-gray-500 py-10">Loading…</p>';
            var ctrl = ('AbortController' in window) ? new AbortController() : null;
            var timer = ctrl ? setTimeout(function () { ctrl.abort(); }, 30000) : null;
            fetch(vpAdminBase() + 'admin/media/browse?q=' + encodeURIComponent(q || ''), {
                credentials: 'same-origin',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                signal: ctrl ? ctrl.signal : undefined
            })
                .then(function (r) {
                    if (!r.ok) throw new Error('HTTP ' + r.status);
                    return r.json();
                })
                .then(function (d) {
                    if (!d || d.ok === false) throw new Error((d && d.error) || 'The server rejected the request.');
                    renderMedia(d.items || []);
                })
                .catch(function (err) {
                    grid.innerHTML = '<p class="col-span-full text-center text-sm text-red-600 py-10">'
                        + ((err && err.name === 'AbortError')
                            ? 'The media library took too long to respond. Please try again.'
                            : 'Could not load the media library. Please try again.')
                        + '</p>';
                })
                .then(function () { if (timer) clearTimeout(timer); });
        }

        document.addEventListener('click', function (e) {
            var open = e.target.closest('[data-vp-media-target]');
            if (open) {
                e.preventDefault();
                target = document.getElementById(open.getAttribute('data-vp-media-target'));
                if (modal) { modal.classList.remove('hidden'); loadMedia(''); }
                return;
            }
            if (e.target.closest('[data-vp-media-close]')) { closeModal(); return; }
            if (modal && e.target === modal) { closeModal(); return; }

            var pick = e.target.closest('[data-vp-media-pick]');
            if (pick && target) {
                e.preventDefault();
                target.value = pick.getAttribute('data-vp-media-pick');
                target.dispatchEvent(new Event('input', { bubbles: true }));
                var prev = document.querySelector('[data-vp-preview-for="' + target.id + '"]');
                if (prev) { prev.src = target.value; prev.classList.remove('hidden'); }
                closeModal();
            }

            var clear = e.target.closest('[data-vp-media-clear]');
            if (clear) {
                e.preventDefault();
                var inp = document.getElementById(clear.getAttribute('data-vp-media-clear'));
                if (inp) {
                    inp.value = '';
                    inp.dispatchEvent(new Event('input', { bubbles: true }));
                    var p = document.querySelector('[data-vp-preview-for="' + inp.id + '"]');
                    if (p) p.classList.add('hidden');
                }
            }
        });

        // Live preview when the URL field is typed into
        document.addEventListener('input', function (e) {
            if (!e.target.id) return;
            var prev = document.querySelector('[data-vp-preview-for="' + e.target.id + '"]');
            if (prev && e.target.value) { prev.src = e.target.value; prev.classList.remove('hidden'); }
        });

        var search = document.getElementById('vp-media-search');
        if (search) {
            var t2 = null;
            search.addEventListener('input', function () {
                clearTimeout(t2);
                t2 = setTimeout(function () { loadMedia(search.value); }, 250);
            });
        }

        var upBtn = document.getElementById('vp-media-upload-btn');
        if (upBtn) {
            var uploadInFlight = false;
            upBtn.addEventListener('click', function () {
                if (uploadInFlight) return;
                var input = document.getElementById('vp-media-upload-input');
                if (!input || !input.files.length) { alert('Choose a file first.'); return; }
                var fd = new FormData();
                fd.append('file', input.files[0]);
                fd.append('folder', 'general');
                fd.append('ajax', '1');
                var meta = document.querySelector('meta[name="csrf-token"]');
                if (meta) fd.append(meta.getAttribute('data-name') || 'csrf_token', meta.getAttribute('content'));
                var ctrl = ('AbortController' in window) ? new AbortController() : null;
                var timer = ctrl ? setTimeout(function () { ctrl.abort(); }, 60000) : null;
                var resetBtn = function () {
                    uploadInFlight = false;
                    upBtn.disabled = false;
                    upBtn.innerHTML = '<i class="ri-upload-2-line"></i> Upload';
                };
                var attempt = function (retried) {
                    if (uploadInFlight) return;
                    uploadInFlight = true;
                    upBtn.disabled = true; upBtn.textContent = 'Uploading…';
                    fetch(vpAdminBase() + 'admin/media/upload', {
                        method: 'POST',
                        body: fd,
                        credentials: 'same-origin',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' },
                        signal: ctrl ? ctrl.signal : undefined
                    })
                        .then(function (r) { return r.json(); })
                        .then(function (d) {
                            resetBtn();
                            if (timer) clearTimeout(timer);
                            // The server rotates the CSRF token on every POST;
                            // resync every token on the page so the form still
                            // saves afterwards.
                            if (d && d.csrf) vpSyncCsrf(d.csrf);
                            if (!d || !d.ok) {
                                // Token expired mid-session: resync and retry once.
                                if (!retried && d && d.csrf && /csrf|session|token/i.test(d.error || '')) {
                                    var m2 = document.querySelector('meta[name="csrf-token"]');
                                    if (m2) {
                                        fd.set(m2.getAttribute('data-name') || 'csrf_token', m2.getAttribute('content'));
                                        return attempt(true);
                                    }
                                }
                                alert(d && d.error ? d.error : 'Upload failed.');
                                return;
                            }
                            input.value = '';
                            loadMedia('');
                        })
                        .catch(function (err) {
                            resetBtn();
                            if (timer) clearTimeout(timer);
                            alert((err && err.name === 'AbortError')
                                ? 'The upload took too long. Please try again with a smaller file.'
                                : 'Upload failed. Please try again.');
                        });
                };
                attempt(false);
            });
        }

        /* ---------------- Page builder drag-and-drop -------------------- */
        var builder = document.getElementById('vp-builder-list');
        if (builder) {
            var dragEl = null;
            builder.addEventListener('dragstart', function (e) {
                var row = e.target.closest('.vp-section-row');
                if (!row) return;
                dragEl = row;
                e.dataTransfer.effectAllowed = 'move';
                row.classList.add('opacity-50');
            });
            builder.addEventListener('dragend', function () {
                if (dragEl) dragEl.classList.remove('opacity-50');
                dragEl = null;
                builder.querySelectorAll('.vp-section-row').forEach(function (r) { r.classList.remove('ring-2'); });
            });
            builder.addEventListener('dragover', function (e) {
                e.preventDefault();
                var row = e.target.closest('.vp-section-row');
                if (!row || row === dragEl) return;
                var rect = row.getBoundingClientRect();
                var before = (e.clientY - rect.top) < rect.height / 2;
                builder.querySelectorAll('.vp-section-row').forEach(function (r) { r.classList.remove('ring-2'); });
                row.classList.add('ring-2');
                if (before) builder.insertBefore(dragEl, row);
                else builder.insertBefore(dragEl, row.nextSibling);
            });
            builder.addEventListener('drop', function (e) {
                e.preventDefault();
                var ids = [];
                builder.querySelectorAll('.vp-section-row[data-id]').forEach(function (r) { ids.push(r.getAttribute('data-id')); });
                var fd = new FormData();
                ids.forEach(function (id) { fd.append('order[]', id); });
                fd.append('pageKey', builder.getAttribute('data-page-key') || 'home');
                fd.append('ajax', '1');
                var tok = document.querySelector('meta[name="csrf-token"]');
                if (tok) fd.append(tok.getAttribute('data-name') || 'csrf_token', tok.getAttribute('content'));
                fetch(vpAdminBase() + 'admin/homepage/reorder', {
                    method: 'POST',
                    body: fd,
                    credentials: 'same-origin',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                })
                    .then(function (r) { return r.json(); })
                    .then(function (d) {
                        if (d && d.csrf) vpSyncCsrf(d.csrf);
                    })
                    .catch(function () {});
            });
        }

        /* ---------------- Repeatable item rows (stats, cards, …) --------- */
        document.addEventListener('click', function (e) {
            var add = e.target.closest('[data-vp-repeat-add]');
            if (add) {
                e.preventDefault();
                var wrap = document.getElementById(add.getAttribute('data-vp-repeat-add'));
                var tpl  = document.getElementById(add.getAttribute('data-vp-repeat-template'));
                if (wrap && tpl) {
                    var div = document.createElement('div');
                    div.innerHTML = tpl.innerHTML.replace(/__INDEX__/g, String(Date.now()).slice(-6));
                    wrap.appendChild(div.firstElementChild);
                }
            }
            var del = e.target.closest('[data-vp-repeat-remove]');
            if (del) {
                e.preventDefault();
                var row = del.closest('[data-vp-repeat-row]');
                if (row) row.remove();
            }
        });
    });
})();
