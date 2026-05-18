# localhost-n8n 🚀

Run **n8n** locally with **SQLite** and **ngrok** for easy webhook testing and automation development.

## ✨ Features

- 🛠️ **Zero Config**: Starts with SQLite by default—no database setup required.
- 🌐 **Public Access**: Integrated **ngrok** tunneling to expose your local instance for webhooks.
- 📦 **Custom Nodes**: Easy management of community/custom nodes via `nodes/package.json`.
- 🐳 **Docker Powered**: Single command setup using Docker Compose.

## 🚀 Quick Start

1. **Clone the repo:**
   ```bash
   git clone https://github.com/No0bmazt3r/localhost-n8n.git
   cd localhost-n8n
   ```

2. **Set up environment:**
   ```bash
   cp .env.example .env
   # Edit .env and add your NGROK_AUTHTOKEN
   ```

3. **Launch:**
   ```bash
   docker compose up --build
   ```

## 📖 Documentation

For detailed setup instructions, troubleshooting, and advanced configuration, see the [**Setup Guide**](SETUP_GUIDE.md).

## 🗄️ Persistence

Your data is stored in `database.sqlite` in the project root. This file is automatically mapped to the n8n container, ensuring your workflows and credentials persist across restarts.

## 📦 Custom Nodes

To add community nodes, simply add them to the `dependencies` section in `nodes/package.json` and restart the container with `--build`.

---

Built for developers who want a fast, local n8n environment.
