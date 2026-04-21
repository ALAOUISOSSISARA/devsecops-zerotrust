# ════════════════════════════════════════════
# Stage 1 — Build Stage
# ════════════════════════════════════════════
FROM alpine:3.21 AS builder

# Install nginx
RUN apk add --no-cache nginx

# ════════════════════════════════════════════
# Stage 2 — Final Hardened Image
# ════════════════════════════════════════════
FROM alpine:3.21

# Labels — metadata de sécurité
LABEL maintainer="secops@secops" \
      version="1.0" \
      description="Hardened nginx image" \
      security.scan="trivy"

# Install nginx minimal
RUN apk add --no-cache nginx=~1 \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# Crée un user non-root dédié
RUN addgroup -g 1001 -S nginxgroup && \
    adduser -u 1001 -S nginxuser -G nginxgroup

# Config nginx pour tourner en non-root
RUN mkdir -p /var/run/nginx \
             /var/lib/nginx/logs \
             /var/lib/nginx/tmp \
             /var/log/nginx && \
    chown -R nginxuser:nginxgroup /var/run/nginx && \
    chown -R nginxuser:nginxgroup /var/lib/nginx && \
    chown -R nginxuser:nginxgroup /var/log/nginx && \
    chown -R nginxuser:nginxgroup /etc/nginx
# Copie config nginx sécurisée
COPY nginx.conf /etc/nginx/nginx.conf

# Permissions read-only sur les fichiers sensibles
RUN chmod 444 /etc/nginx/nginx.conf

# Port non-privilégié (>1024 pour non-root)
EXPOSE 8080

# Page HTML minimale
RUN mkdir -p /usr/share/nginx/html && \
    echo '<html><body><h1>OK</h1></body></html>' > /usr/share/nginx/html/index.html && \
    chown -R nginxuser:nginxgroup /usr/share/nginx/html
# Bascule vers user non-root
USER nginxuser

# Healthcheck — Zero Trust : on vérifie que le service est sain
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://127.0.0.1:8080/ || exit 1

# Lancement nginx
CMD ["nginx", "-g", "daemon off;"]
