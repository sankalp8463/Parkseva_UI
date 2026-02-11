#!/bin/bash
set -e

echo "🚀 Starting deployment..."

# Install dependencies
echo "📦 Installing dependencies..."
npm ci --production=false

# Build Angular app
echo "🔨 Building application..."
npm run build

# Deploy to Nginx
echo "📂 Deploying to Nginx..."
sudo rm -rf /usr/share/nginx/html/*
sudo cp -r dist/frontend/browser/* /usr/share/nginx/html/

# Set permissions
sudo chown -R nginx:nginx /usr/share/nginx/html
sudo chmod -R 755 /usr/share/nginx/html

# Restart Nginx
echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx

echo "✅ Deployment complete!"
echo "🌐 Visit: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
