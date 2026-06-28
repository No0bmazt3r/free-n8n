const target = process.argv[2];

fetch(target)
  .then(res => res.json())
  .then(data => {
    const tunnel = data.tunnels?.find(t => t.public_url);
    if (tunnel) {
      process.stdout.write(tunnel.public_url);
    }
  })
  .catch(() => {
    // Silently fail, bash loop will try again
    process.exit(1); 
  });
