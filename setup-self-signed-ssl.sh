#!/bin/bash
set -e

echo "🔒 Creating Self-Signed SSL Certificate"

# Create SSL directory
sudo mkdir -p /etc/nginx/ssl

# Generate self-signed certificate (valid for 365 days)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx-selfsigned.key \
  -out /etc/nginx/ssl/nginx-selfsigned.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"

# Set permissions
sudo chmod 600 /etc/nginx/ssl/nginx-selfsigned.key
sudo chmod 644 /etc/nginx/ssl/nginx-selfsigned.crt

echo "✅ SSL certificate created at /etc/nginx/ssl/"
echo "📝 Now update nginx config"
