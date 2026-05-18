#!/bin/sh
set -e

# Install custom nodes if any are defined
if [ -f "/home/node/.n8n/nodes/package.json" ]; then
  printf "Checking for custom nodes in /home/node/.n8n/nodes/package.json...\n"
  cd /home/node/.n8n/nodes
  # Only run npm install if dependencies are present
  if grep -q "\"dependencies\":\s*{\s*\"" package.json; then
    printf "Installing custom nodes...\n"
    npm install --production
  else
    printf "No custom nodes found in package.json dependencies.\n"
  fi
  cd /home/node
fi

NGROK_API="http://ngrok:4040/api/tunnels"

printf "Waiting for ngrok to be ready...\n"
# wait up to 30s for ngrok to publish a tunnel
for i in $(seq 1 30); do
  sleep 1
  if curl -s "$NGROK_API" | grep -q "public_url"; then
    break
  fi
done

PUB_URL=$(curl -s "$NGROK_API" | awk -F'"' '/public_url/ {print $4; exit}')
if [ -z "$PUB_URL" ]; then
  printf "Warning: failed to fetch ngrok public_url; continuing without WEBHOOK_URL\n"
else
  printf "Found ngrok public URL: %s\n" "$PUB_URL"
  export WEBHOOK_URL="$PUB_URL"
fi

# Start n8n (without built-in tunnel as we use ngrok)
exec n8n start --host=0.0.0.0 --port=5678
