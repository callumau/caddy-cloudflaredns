ARG CADDY_VERSION

# Stage 1: Build Caddy with the Cloudflare DNS plugin
FROM caddy:builder AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare

# Stage 2: Final image
FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
