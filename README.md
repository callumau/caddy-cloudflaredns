# Caddy + Cloudflare DNS Validation

Uses [Cloudflare](https://github.com/caddy-dns/cloudflare) Caddy DNS plugin to automatically build a packaged docker container on a new release of Caddy.

## Usage

To use the pre-built Docker image, pull it from the GitHub Container Registry:
```bash
docker pull ghcr.io/callumau/caddy-cloudflare/caddy:latest
```

Caddyfile requirements can be found on the original Cloudflare Caddy DNS plugin repo: [https://github.com/caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare?tab=readme-ov-file#configuration)

## Build

```bash
git clone 
docker build \
--build-arg CADDY_VERSION=${{ env.latest_tag }} \
-t ghcr.io/callumau/caddy-cloudflare/caddy:${{ env.latest_tag }} \
-t ghcr.io/callumau/caddy-cloudflare/caddy:latest .
