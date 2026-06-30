FROM caddy:2-builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-l4

FROM caddy:2

COPY --from=0 /usr/bin/caddy /usr/bin/caddy