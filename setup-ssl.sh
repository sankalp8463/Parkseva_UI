#!/bin/bash
set -e

echo "🔒 SSL Setup Script"
echo ""

# Check if domain is provided
if [ -z "$1" ]; then
  echo "Usage: ./setup-ssl.sh yourdomain.com"
  echo "Example: ./setup-ssl.sh parkease.example.com"
  exit 1
fi

DOMAIN=$1
EMAIL=${2:-admin@$DOMAIN}

echo "Domain: $DOMAIN"
echo "Email: $EMAIL"
echo ""

# Install Certbot
echo "📦 Installing Certbot..."
sudo dnf install -y certbot python3-certbot-nginx

# Stop Nginx temporarily
echo "⏸️  Stopping Nginx..."
sudo systemctl stop nginx

# Get SSL certificate
echo "🔐 Obtaining SSL certificate..."
sudo certbot certonly --standalone -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

# Start Nginx
echo "▶️  Starting Nginx..."
sudo systemctl start nginx

# Setup auto-renewal
echo "🔄 Setting up auto-renewal..."
sudo systemctl enable certbot-renew.timer
sudo systemctl start certbot-renew.timer

echo ""
echo "✅ SSL certificate obtained!"
echo "📝 Now update nginx config with SSL settings"
echo ""
echo "Certificate files:"
echo "  - /etc/letsencrypt/live/$DOMAIN/fullchain.pem"
echo "  - /etc/letsencrypt/live/$DOMAIN/privkey.pem"
