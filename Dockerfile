# FocusVault Chrome Extension - Dockerfile
# This Dockerfile sets up a development and testing environment for the Chrome extension

FROM node:18-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    curl \
    git \
    python3 \
    make \
    g++ \
    bash

# Copy package files if they exist
COPY package*.json ./

# Install Node dependencies if package.json exists
RUN if [ -f package.json ]; then npm ci; fi

# Install global tools for extension development
RUN npm install -g \
    web-ext \
    http-server \
    serve

# Copy source code
COPY . .

# Expose ports
EXPOSE 3000 3001 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000 || curl -f http://localhost:8000 || exit 1

# Default command - start HTTP server for local testing
CMD ["http-server", "-p", "3000", "-o", "/index/index.html"]
