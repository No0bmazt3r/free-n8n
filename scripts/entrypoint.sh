#!/bin/sh
set -e

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

# Start n8n
exec n8n start --tunnel --host=0.0.0.0 --port=5678
