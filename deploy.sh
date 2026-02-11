#!/bin/bash
set -e

echo "🚀 Starting deployment..."

# Build Docker image
docker build -t parkseva-frontend .

# Stop and remove old container
docker stop parkseva-frontend || true
docker rm parkseva-frontend || true

# Run new container
docker run -d \
  --name parkseva-frontend \
  --restart unless-stopped \
  -p 80:80 \
  parkseva-frontend

# Cleanup
docker image prune -f

echo "✅ Deployment complete!"
