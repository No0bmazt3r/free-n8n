# 🚀 localhost-n8n Setup Guide
## Run n8n Locally with SQLite & ngrok Tunneling

---

## 📖 What is This?

This project allows you to run **n8n** (a workflow automation tool) locally on your machine with:
- **SQLite Database** - Simple, file-based database (no complex setup needed)
- **ngrok Tunneling** - Automatically exposes your local n8n to the public internet
- **Custom Nodes** - Add your own custom workflow nodes easily
- **Zero Configuration** - Works out of the box with sensible defaults

Perfect for:
- 🔗 Testing webhooks from services like Stripe, GitHub, Slack
- 🛠️ Building and testing automation workflows locally
- 🧪 Prototyping before deploying to production

---

## 📋 Prerequisites

Install these tools before starting:

| Tool | Purpose | Download |
|------|---------|----------|
| **Git** | Version control | [git-scm.com](https://git-scm.com/) |
| **Docker** | Container runtime | [docker.com](https://www.docker.com/) |
| **Docker Compose** | Multi-container orchestration | Included with Docker Desktop |
| **ngrok Account** | Tunneling service (free tier) | [ngrok.com](https://ngrok.com/) |

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
2. Sign up or log in
3. Copy your **Auth Token**
4. Open `.env` and paste it:
```env
NGROK_AUTHTOKEN=your_actual_token_here
GENERIC_TIMEZONE=UTC  # Change to your timezone
```

### Step 3: Launch!
```bash
docker compose up --build
```

Wait for the startup message in the logs:
```
Found ngrok public URL: https://xxxx-xxxx.ngrok.io
```

### Step 4: Access n8n
- **Local Access**: http://localhost:5678
- **Public Access**: The URL from the startup message

---

## 🗄️ SQLite Database

All data is stored in `database.sqlite` in the root of this project.

### Backing Up
Simply copy the `database.sqlite` file:
```bash
cp database.sqlite database.sqlite.backup
```

### Resetting Everything
To start fresh:
```bash
docker compose down
rm database.sqlite*
docker compose up --build
```

---

## 🌐 ngrok Tunneling

External services can't reach your local machine directly. ngrok creates a **public URL** that forwards traffic to your local n8n instance.

### Important: URL Changes
Your ngrok URL changes every time you restart! You will need to update your webhook URLs in external services (like Stripe or GitHub) when this happens.

---

## 📦 Installing Custom Nodes

### How to Add Custom Nodes

1. Open `nodes/package.json`:
```json
{
  "name": "installed-nodes",
  "private": true,
  "dependencies": {
    "n8n-nodes-custom-form": "0.1.1"
  }
}
```

2. Add your desired community node package to the `dependencies` section.

3. Rebuild and restart:
```bash
docker compose down
docker compose up --build
```

The `entrypoint.sh` script will automatically run `npm install` inside the container when it detects new dependencies.

---

## 🔧 Environment Configuration

Edit `.env` to configure n8n:

| Variable | Purpose |
|----------|---------|
| `NGROK_AUTHTOKEN` | **Required**. Your ngrok token. |
| `GENERIC_TIMEZONE` | Timezone for your workflows (e.g., `Europe/Berlin`). |
| `N8N_BASIC_AUTH_ACTIVE` | Set to `true` to enable password protection for the UI. |
| `N8N_BASIC_AUTH_USER` | Username for basic auth. |
| `N8N_BASIC_AUTH_PASSWORD` | Password for basic auth. |

---

## 📁 Project Structure

```
localhost-n8n/
├── README.md                 ← Overview and features
├── SETUP_GUIDE.md            ← Detailed setup (this file)
├── .env                      ← Your configuration
├── .env.example             ← Template for .env
├── docker-compose.yml       ← Docker services definition
├── database.sqlite          ← Your actual n8n data (auto-created)
├── nodes/
│   └── package.json        ← Custom nodes dependencies
└── scripts/
    └── entrypoint.sh       ← Startup logic and ngrok handling
```

---

## 🚀 Common Tasks

### View Logs
```bash
docker compose logs -f n8n
```

### Check ngrok Status
Visit: http://localhost:4040

---

## 🐛 Troubleshooting

### "ngrok not starting"
Check your auth token in `.env`. Ensure it matches exactly what is in your ngrok dashboard.

### "Database is locked"
SQLite may lock if multiple processes try to access it. If this happens, run `docker compose down` and then `docker compose up`.

---

**Happy automating!** 🎉
