# Caddy + Cloudflare DNS Validation

Uses Github actions to automatically build a packaged container on a new release of Caddy with [Cloudflare](https://github.com/caddy-dns/cloudflare) Caddy DNS plugin.

## Usage

To use the pre-built Docker image, pull it from the GitHub Container Registry:
```bash
docker pull ghcr.io/callumau/caddy-cloudflaredns/caddy:latest
```

Caddyfile requirements can be found on the original Cloudflare Caddy DNS plugin repo: [https://github.com/caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare?tab=readme-ov-file#configuration)
