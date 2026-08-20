# Halyk Petroleum — Industrial Manufacturing Website

A CodeIgniter 3 PHP application for an industrial manufacturing company, featuring:

- **Public site**: Home, Products, Services, Industries, Blog, News, Careers, FAQ, Contact, RFQ (quote requests)
- **Admin panel**: Dashboard, Quotes, Products, Categories, Industries, Blog, News, Careers, Users, SEO, Settings, Media, Email logs, Audit trail, Notifications
- **AI Chat Assistant**: Floating widget with optional LLM integration (OpenAI-compatible)
- **Auth system**: Login/register, password reset, RBAC (Super Admin, Admin, Sales, Engineer, Editor, Customer)
- **Email**: SMTP (cPanel) or Resend API with fallback to PHP `mail()`
- **Security**: CSRF, rate limiting, session management, bcrypt passwords

---

## Portable cPanel Deployment

**No Terminal, SSH, Composer, Node.js, or CLI commands required.**

```
Upload Files → Create Database → Import SQL → Edit .env → Open Website
```

See [`DEPLOYMENT.md`](DEPLOYMENT.md) for the complete step-by-step guide.

### Quick Steps

1. **Upload** `application-deployment.zip` via cPanel File Manager and extract
2. **Create** a MySQL database and user in cPanel
3. **Import** `database/production.sql` via phpMyAdmin
4. **Edit** `.env` with your database credentials and domain
5. **Open** `https://yourdomain.com` — the application works immediately

### Default Admin

| Field    | Value                          |
|----------|--------------------------------|
| Email    | `admin@halykpetroleum-kz.com` |
| Password | `Nigeria1234@`                |

**Change this password immediately** after first login.

---

## File Structure

```
/
├── .env                    # Environment config (gitignored)
├── .env.example            # Template for .env
├── .htaccess               # Apache rewrite rules
├── index.php               # Application front controller
├── application/            # CodeIgniter application code
├── assets/                 # Public CSS, JS, images, uploads
├── system/                 # CodeIgniter 3 framework
├── database/               # Database files
│   └── production.sql      # Complete production database
├── docs/                   # Documentation
├── install/                # Optional CLI tools (not needed for deployment)
├── scripts/                # Development helper scripts
├── tests/                  # Acceptance tests
├── DEPLOYMENT.md           # cPanel deployment guide
└── application-deployment.zip  # Deployment package
```

## Development

To run locally with PHP's built-in server:

```bash
cp .env.example .env
# Edit .env with your local database credentials
# Import database/production.sql via phpMyAdmin or MySQL CLI
bash scripts/start.sh
```

## License

Proprietary — All rights reserved.