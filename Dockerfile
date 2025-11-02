# PRISM Framework Website - Production Dockerfile
# Multi-stage build for optimized production deployment

# Stage 1: Build stage (for any future build steps)
FROM node:20-alpine AS builder

WORKDIR /app

# Copy website files
COPY website/ ./website/
COPY assets/ ./assets/

# Stage 2: Production stage with Nginx
FROM nginx:alpine

# Install curl for healthcheck
RUN apk add --no-cache curl

# Remove default Nginx configuration
RUN rm -rf /usr/share/nginx/html/*

# Copy website files to Nginx web root
COPY --from=builder /app/website /usr/share/nginx/html
COPY --from=builder /app/assets /usr/share/nginx/html/assets

# Copy custom Nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Create non-root user for Nginx
RUN addgroup -g 101 -S nginx && \
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Switch to non-root user
USER nginx

# Expose port 80
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Labels for metadata
LABEL maintainer="PRISM Contributors" \
      version="2.3.0" \
      description="PRISM Framework - Enterprise AI Context Management Website" \
      org.opencontainers.image.source="https://github.com/afiffattouh/hildens-prism"

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
