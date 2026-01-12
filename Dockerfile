FROM golang:alpine AS builder

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build --with github.com/caddy-dns/cloudflare

# Stage 2: Final image
FROM caddy:${CADDY_VERSION}

COPY --from=builder /go/bin/caddy /usr/bin/caddy
