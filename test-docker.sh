#!/bin/bash

echo "🧪 Testing Docker build locally..."

# Build image
docker build -t parkseva-frontend-test .

# Run container
docker run -d --name parkseva-test -p 8080:80 parkseva-frontend-test

echo "✅ Container running at http://localhost:8080"
echo "Stop with: docker stop parkseva-test && docker rm parkseva-test"
