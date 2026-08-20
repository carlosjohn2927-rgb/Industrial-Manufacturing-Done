// Vortex Precision - admin JS
(function () {
    'use strict';
    document.addEventListener('DOMContentLoaded', function () {
        // Sidebar toggle (mobile)
        var t = document.getElementById('vp-admin-toggle');
        var sb = document.querySelector('aside');
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
    });
})();
