# Admin Guide — Vortex Precision

Sign in at `/admin/login` with your staff account. A fresh installation has no seeded passwords: `install/install.php` creates the first Super Admin with the password you provide via `VP_ADMIN_PASSWORD` — or a randomly generated temporary password printed by the installer. Temporary passwords are flagged in the database, and the account's first login is redirected to its edit screen so the password must be changed before using the rest of the admin area. The sidebar then gives you access to all admin areas.

## Dashboard

- Counts: new RFQs, products, open contacts, users
- Doughnut chart of quotes by status
- Recent RFQs (last 10)
- Recent activity (last 15 audit log entries)

## Quotes

This is the most-used screen. List view supports:
- Free-text search (quote #, company, contact, email)
- Filter by status / assignee
- CSV export (top-right)

Click any quote to see:
- All line items
- Full status history (immutable)
- Activity timeline (every action with actor, IP, timestamp)
- Assignment controls
- Status update form (only valid forward transitions are shown)
- Internal note form (separate from customer-facing notes)
- PDF generation (rendered as printable HTML, downloadable via the browser's print dialog)
- Delete (Super Admin only)

## Products

- Search by name, SKU, description
- Filter by category
- Create / edit / delete
- Form supports: primary image upload (auto-resized to 1600px), dynamic specifications, related products, industries, SEO meta, featured flag, active/draft

## Categories

Flat list ordered by `order`. Used for product groupings on the public site.

## Industries

List + detail on public site. Capabilities (e.g. "ASME B31.3, API 610") are a comma-separated field stored as a JSON array.

## Blog / News

Standard CMS. Drafts vs published. Each post has excerpt, content (HTML allowed), category, tags, author, status, publish date, SEO meta.

## Careers

- List of open positions
- Form to create a new role (title, slug auto-generated, department, location, type, experience, salary, description, requirements, benefits, active flag, posted + closing dates)
- "Applications" link next to each role shows submitted applications with resume download links

## Contacts

Submitted via the public contact form. List view shows status (NEW = unread), subject, department, received time. Click to view, then "Reply via email" opens your mail client.

## FAQs

Question + answer + category. Order within category controls display order.

## Downloads

Title, description, file URL (or relative path under `/assets/files/`), type, category, file size. Public download counter is shown.

## Testimonials / Partners

Editable lists used on the home page.

## Media

Upload images and files to a chosen folder. Images are auto-resized to 1600px max width. The media list is paginated; click "View" to open.

## Users

- List, search, filter by role
- Create new user (password required, 8+ chars)
- Edit (change role, status; password is optional on edit)
- Delete (Super Admin only; can't delete yourself)

## Settings

Group by group: GENERAL, HERO, STATS, CONTACT, RFQ, ABOUT, SEO, CHAT, etc. Each row has a key, type (STRING / TEXT / INT / BOOL / JSON), and value. Edit inline, click "Save all settings". Settings are cached in-request; no need to clear any cache.

## SEO

Dedicated screen under **System → SEO** for search-engine settings:

- Default title, title suffix, meta description, keywords, robots directive
- Canonical domain (used to generate canonical URLs, `robots.txt`, `sitemap.xml`)
- Social sharing image (`og:image`), Twitter handle, Facebook App ID
- Google / Bing site-verification codes
- JSON-LD structured data (Organization schema by default, or a custom document)

A `robots.txt` and `sitemap.xml` are generated automatically at those URLs and include all public pages, products, industries, blog posts, news and careers.

## AI chat

The floating chat widget on the public site is configured under **Settings → CHAT group** (see `docs/AI_CHAT.md`). By default it answers locally from FAQs, products, industries and contact info with no external service. To use a real LLM, set `chat_ai_provider` to `openai`/`custom` and provide `chat_ai_api_key` (or set `VP_AI_API_KEY` in the environment).

## Audit log

Append-only log of every admin mutation. Filter by user, action, resource. Useful for compliance and post-incident review.

## Notifications

In-app notifications. Mark individual items as read. Currently populated by the system; can be extended to push notifications (WebSockets out of scope).

## Common admin actions

- **Log out**: top-right of any admin page, or `GET /admin/logout`.
- **Switch back to public site**: any "View public site" link in the footer.
- **Change your password**: `/admin/users/edit/<your-id>`.

## Keyboard tips

- `Ctrl+S` / `Cmd+S` does NOT save the form (browsers handle it as "save page"). Click the "Save" button.
- Browser autocomplete works for login email.

## Limits and quotas

- Per-IP: 100 requests / 15 minutes on public pages
- Per-IP+email: 5 RFQ submissions / hour
- Login: 5 failed attempts / 15 minutes
- File uploads: 8 MB default (configurable per controller)
