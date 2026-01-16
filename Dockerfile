ARG CADDY_VERSION

FROM golang:alpine AS builder

ARG CADDY_VERSION

# Install build dependencies
# git: required for xcaddy to fetch dependencies
# ca-certificates: required for HTTPS
# mailcap: required for /etc/mime.types
RUN apk add --no-cache git ca-certificates mailcap

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with the Cloudflare plugin
# CGO_ENABLED=0 ensures a statically linked binary for scratch
# -ldflags "-s -w" strips debug information to reduce size
ENV CGO_ENABLED=0
ENV GOFLAGS="-ldflags=-s"
RUN xcaddy build v${CADDY_VERSION} \
    --output /go/bin/caddy \
    --with github.com/caddy-dns/cloudflare

# Create a default Caddyfile and setup user
RUN mkdir -p /etc/caddy && echo "# Default Caddyfile" > /etc/caddy/Caddyfile
# Create user caddy (UID 1000) to run as non-root
RUN adduser -D -u 1000 caddy
# Create directories and set permissions for caddy user
# ensuring they are writable when copied to scratch
RUN mkdir -p /config /data && chown -R caddy:caddy /config /data

# Final stage: minimal scratch image
FROM scratch

# Copy certificates and mime types from builder
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/mime.types /etc/mime.types
COPY --from=builder /etc/caddy/Caddyfile /etc/caddy/Caddyfile

# Copy user/group details to enable non-root user
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copy the compiled binary
COPY --from=builder /go/bin/caddy /usr/bin/caddy

# Copy config and data directories with correct ownership
COPY --from=builder --chown=caddy:caddy /config /config
COPY --from=builder --chown=caddy:caddy /data /data

# Set environment variables for Caddy
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

# Define volumes for data persistence
VOLUME /config
VOLUME /data

# Expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

# Run as non-root user
USER caddy

# Run Caddy
CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]