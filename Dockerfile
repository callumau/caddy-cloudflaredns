FROM golang:alpine AS builder


ARG CADDY_VERSION


RUN apk add --no-cache git
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build v${CADDY_VERSION} \
    --with github.com/caddy-dns/cloudflare

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /go/bin/caddy /usr/bin/caddy