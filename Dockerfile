# FixieRun Dashboard - Docker Configuration
# Multi-stage build for optimized production deployment

# Stage 1: Build stage (if needed for future enhancements)
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files (if you add build tools later)
# COPY package*.json ./
# RUN npm ci --only=production

# Copy source files
COPY . .

# Stage 2: Production stage
FROM nginx:alpine AS production

# Install curl for health checks
RUN apk add --no-cache curl

# Copy static files to nginx
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/manifest.json /usr/share/nginx/html/
COPY --from=builder /app/*.png /usr/share/nginx/html/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create nginx user and set permissions
RUN addgroup -g 1001 -S nginx-user && \
    adduser -S nginx-user -G nginx-user && \
    chown -R nginx-user:nginx-user /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# Expose port
EXPOSE 80

# Labels for metadata
LABEL maintainer="FixieRun Team"
LABEL version="1.0.0"
LABEL description="FixieRun Dashboard - Fitness tracking with blockchain integration"

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
