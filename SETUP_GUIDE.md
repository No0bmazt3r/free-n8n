# 🚀 localhost-n8n Setup Guide
## Run n8n Locally with SQLite & ngrok Tunneling

---

## 📖 What is This?

This project allows you to run **n8n** (a workflow automation tool) locally on your machine with:
- **SQLite Database** - Simple, file-based database (no complex setup needed)
- **ngrok Tunneling** - Automatically exposes your local n8n to the public internet
- **Custom Nodes** - Add your own custom workflow nodes
- **Zero Configuration** - Works out of the box with sensible defaults

Perfect for:
- 🔗 Testing webhooks from services like Stripe, GitHub, Slack
- 🛠️ Building and testing automation workflows locally
- 🧪 Prototyping before deploying to production
- 📦 Installing custom nodes for specialized workflows

---

## 📋 Prerequisites

Install these tools before starting:

| Tool | Purpose | Download |
|------|---------|----------|
| **Git** | Version control | [git-scm.com](https://git-scm.com/) |
| **Docker** | Container runtime | [docker.com](https://www.docker.com/products/docker-desktop/) |
| **Docker Compose** | Multi-container orchestration | Included with Docker Desktop |
| **ngrok Account** | Tunneling service (free tier) | [ngrok.com](https://ngrok.com/) |

> macOS/Windows: Download Docker Desktop (includes Docker + Docker Compose)
> Linux: Install Docker and Docker Compose separately

---

## ⚡ Quick Start (5 Minutes)

### Step 1: Clone & Setup
```bash
git clone https://github.com/No0bmazt3r/localhost-n8n.git
cd localhost-n8n
cp .env.example .env
```

### Step 2: Get Your ngrok Auth Token
1. Go to [ngrok Dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)
2. Sign up (free account) or log in
3. Copy your **Auth Token**
4. Open `.env` and paste it:
```env
NGROK_AUTHTOKEN=your_actual_token_here
GENERIC_TIMEZONE=America/New_York  # Change to your timezone
```

### Step 3: Launch!
```bash
docker-compose up --build
```

Wait for the startup message:
```
Public URL: https://xxxx-xx-xxx-xxx-xx.ngrok.io
Starting n8n with WEBHOOK_URL=https://xxxx-xx-xxx-xxx-xx.ngrok.io
```

### Step 4: Access n8n
- **Local Access**: http://localhost:5678
- **Public Access**: https://xxxx-xx-xxx-xxx-xx.ngrok.io (from the startup message)

Done! 🎉

---

## 🗄️ SQLite Database Explained

### What is SQLite?
SQLite is a simple, file-based database. No server needed. Perfect for development!

### Your Database File
```
database.sqlite      ← Your actual data
database.sqlite-shm  ← Temporary shadow file (ignore)
database.sqlite-wal  ← Temporary write-ahead log (ignore)
```

### Location
All data is stored in:
```
/home/node/.n8n/database.sqlite
```

Inside Docker, this maps to your local project folder via volume mounting:
```yaml
volumes:
  - ./:/home/node/.n8n  # Your project folder ↔ Container
```

### Backing Up Your Data
Simply copy the `database.sqlite` file:
```bash
# Backup before major changes
cp database.sqlite database.sqlite.backup

# Restore if needed
cp database.sqlite.backup database.sqlite
```

### Resetting Everything
To start fresh with an empty database:
```bash
# Stop the containers
docker-compose down

# Delete the database
rm database.sqlite*

# Start again
docker-compose up --build
```

---

## 🌐 ngrok Tunneling Explained

### How It Works

```
Your Local Machine          Internet              External Services
┌─────────────────┐        ┌──────────┐          ┌─────────────────┐
│  n8n (5678)     │◄──────►│  ngrok   │◄────────►│  Stripe Webhook │
│  Workflows      │        │ Tunnel   │          │  GitHub Events  │
│  Webhooks       │        │          │          │  Slack Messages │
└─────────────────┘        └──────────┘          └─────────────────┘
```

### Why ngrok?

External services can't reach your local machine directly. ngrok creates a **public URL** that forwards traffic to your local n8n instance.

### What Happens on Startup

1. **Docker launches ngrok container** with your auth token
2. **ngrok creates a public URL** (e.g., `https://abcd-1234.ngrok.io`)
3. **Entrypoint script** fetches the URL from ngrok API
4. **URL is passed to n8n** as `WEBHOOK_URL` environment variable
5. **n8n automatically configures webhooks** to use the public URL

### Your ngrok URL

Check the startup output:
```bash
docker-compose up
# Look for:
# Public URL: https://abcd-1234-abcd-1234.ngrok.io
```

Or check ngrok dashboard at http://localhost:4040

### Important: URL Changes

Your ngrok URL changes every time you restart! This is **normal**.

When restarting, update webhook URLs in your external services:
- ✅ Stripe webhooks
- ✅ GitHub webhooks
- ✅ Custom integrations

For a **static URL**, upgrade to a paid ngrok plan.

---

## 📦 Installing Custom Nodes

### What are Custom Nodes?

Custom nodes extend n8n with new capabilities. Examples:
- Database operations
- API integrations
- Custom business logic
- Specialized data processing

### How to Add Custom Nodes

#### Method 1: Edit `nodes/package.json` (Recommended)

1. Open `nodes/package.json`:
```json
{
  "name": "installed-nodes",
  "private": true,
  "dependencies": {
    "n8n-nodes-custom-form": "0.1.1",
    "n8n-nodes-puppeteer-extended": "0.1.0"
  }
}
```

2. Add your custom node package:
```json
{
  "name": "installed-nodes",
  "private": true,
  "dependencies": {
    "n8n-nodes-custom-form": "0.1.1",
    "n8n-nodes-puppeteer-extended": "0.1.0",
    "n8n-nodes-my-custom-node": "1.0.0"  ← Add here
  }
}
```

3. Rebuild and restart:
```bash
docker-compose down
docker-compose up --build
```

#### Method 2: Install During Runtime (Temporary)

Inside n8n UI:
1. Click **Settings** ⚙️
2. Go to **Community Nodes**
3. Search for node package
4. Click **Install**

> ⚠️ Reinstalling containers will lose this installation. Use Method 1 for permanent installs.

### Finding Custom Nodes

Search npm registry:
```bash
npm search n8n-nodes
```

Or browse:
- [NPM Registry](https://www.npmjs.com/search?q=n8n-nodes)
- [n8n Official Nodes](https://docs.n8n.io/integrations/)

### Example: Add Database Node
```json
"dependencies": {
  "n8n-nodes-custom-database": "^1.0.0"
}
```

### Example: Add HTTP Advanced
```json
"dependencies": {
  "n8n-nodes-http-advanced": "^2.1.0"
}
```

---

## 🔧 Environment Configuration

### SQLite-Specific Settings

Edit `.env`:
```env
# Timezone for your workflows
GENERIC_TIMEZONE=America/New_York

# ngrok tunnel token (REQUIRED)
NGROK_AUTHTOKEN=your_token_here
```

That's it! SQLite requires **zero additional configuration**.

### Optional: SMTP (For User Invitations)

To invite team members via email:

```env
N8N_SMTP_HOST=smtp.gmail.com
N8N_SMTP_PORT=587
N8N_SMTP_USER=your-email@gmail.com
N8N_SMTP_PASS=your-16-char-app-password
N8N_SMTP_SENDER=your-email@gmail.com
N8N_SMTP_SSL=false
```

Get Gmail App Password:
1. Enable 2FA on your Google Account
2. Go to [Google Account Settings](https://myaccount.google.com/apppasswords)
3. Select "Mail" and "Windows Computer"
4. Copy the 16-character password

---

## 📁 Project Structure

```
localhost-n8n/
├── .env                      ← Your configuration (EDIT THIS)
├── .env.example             ← Template (DO NOT EDIT)
├── docker-compose.yml       ← SQLite setup (default)
├── docker-compose.postgres.yml  ← PostgreSQL alternative (ignore)
├── database.sqlite          ← Your actual data (auto-created)
├── database.sqlite-shm      ← Temp file (ignore)
├── database.sqlite-wal      ← Temp file (ignore)
│
├── n8n/
│   └── Dockerfile          ← Docker image definition
│
├── nodes/
│   └── package.json        ← Custom nodes list (EDIT TO ADD NODES)
│
├── scripts/
│   └── entrypoint.sh       ← Startup script (handles ngrok URL)
│
├── config/                 ← n8n configuration
├── storage/                ← Execution logs & data
└── docs/                   ← Documentation
```

---

## 🚀 Common Tasks

### Start the Services
```bash
docker-compose up --build
```

### Stop Everything
```bash
docker-compose down
```

### View Logs
```bash
# All containers
docker-compose logs -f

# Just n8n
docker-compose logs -f n8n

# Just ngrok
docker-compose logs -f ngrok
```

### Restart After Changes
```bash
# If you edited .env or nodes/package.json
docker-compose down
docker-compose up --build
```

### Check ngrok Status
Visit: http://localhost:4040/status

### Access n8n
- **Local**: http://localhost:5678
- **Public**: https://<your-ngrok-url> (from startup logs)

### Download Workflows
In n8n UI: **File → Download (JSON)**

### Import Workflows
In n8n UI: **File → Import → Select JSON**

---

## 🐛 Troubleshooting

### "ngrok not starting"
```bash
# Check your auth token
docker-compose logs ngrok

# If token is invalid:
# 1. Get new token from https://dashboard.ngrok.com
# 2. Update .env with correct token
# 3. Restart: docker-compose down && docker-compose up --build
```

### "Cannot reach n8n locally"
```bash
# Make sure n8n is running
docker-compose logs n8n

# Access via: http://localhost:5678
# NOT https:// (local access is HTTP only)
```

### "Webhooks not working"
```bash
# 1. Check startup output for ngrok URL
docker-compose logs n8n | grep "Public URL"

# 2. Use that URL in your webhook configuration
# 3. Make sure webhook URL hasn't changed (restart creates new URL)
```

### "Database is locked"
```bash
# SQLite doesn't handle concurrent access well
# If you see "database is locked":
docker-compose down
docker-compose up --build
```

### "Custom node not appearing"
```bash
# 1. Check syntax in nodes/package.json
# 2. Rebuild containers
docker-compose down
docker-compose up --build

# 3. Check logs
docker-compose logs n8n | grep -i "node"

# 4. Restart n8n after nodes are loaded (wait 30 seconds)
```

### "Out of disk space"
SQLite database can grow large with execution logs:
```bash
# Clean execution history in n8n UI:
# Settings → Executions → Delete old executions

# Or manually clear logs:
rm storage/logs/*.log
docker-compose restart n8n
```

---

## 💡 Best Practices

### Development Workflow
1. ✅ Start with SQLite (simple, works locally)
2. ✅ Build and test workflows locally
3. ✅ Back up `database.sqlite` before big changes
4. ✅ Use ngrok to test webhook integrations
5. ✅ Download workflows as JSON backup

### Security Notes
- 🔒 ngrok URLs are **public** - anyone with the URL can access
- 🔒 Use strong credentials in n8n (Settings → Security)
- 🔒 Don't commit `.env` to git (already in `.gitignore`)
- 🔒 Keep ngrok auth token **secret**
- 🔒 SQLite is fine for dev, use PostgreSQL for production

### Performance Tips
- Keep execution history clean (delete old executions)
- Don't store huge datasets in workflow variables
- Use database nodes for large data operations
- Monitor `database.sqlite` file size

### Migration Path
Ready for production?
1. Switch to PostgreSQL: `docker-compose -f docker-compose.postgres.yml up`
2. Export workflows: n8n UI → File → Download
3. Import to production instance
4. Switch webhooks to production URL

---

## 📚 Further Reading

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Nodes Library](https://docs.n8n.io/integrations/)
- [ngrok Documentation](https://ngrok.com/docs)
- [SQLite Documentation](https://www.sqlite.org/docs.html)

---

## ✅ Checklist Before Production

- [ ] Test all webhooks with live external services
- [ ] Back up `database.sqlite` regularly
- [ ] Document all workflows
- [ ] Test custom nodes thoroughly
- [ ] Set strong n8n credentials
- [ ] Monitor ngrok status page
- [ ] Plan for PostgreSQL migration if needed

---

## 🆘 Need Help?

1. Check logs: `docker-compose logs -f`
2. Verify `.env` configuration
3. Make sure ngrok auth token is valid
4. Check Docker is running: `docker ps`
5. Restart everything: `docker-compose down && docker-compose up --build`

---

**Happy automating!** 🎉
