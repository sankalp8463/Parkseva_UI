# SSL Setup Guide for AWS EC2

## Prerequisites
- Domain name (e.g., parkease.example.com)
- Domain DNS pointing to your EC2 public IP
- Port 443 open in EC2 Security Group

## Step 1: Update Security Group

In AWS Console → EC2 → Security Groups:
- Add rule: HTTPS, Port 443, Source: 0.0.0.0/0

## Step 2: Point Domain to EC2

In your domain registrar (GoDaddy, Namecheap, etc.):
- Create A record: `@` or `yourdomain.com` → Your EC2 Public IP
- Wait 5-10 minutes for DNS propagation

Verify:
```bash
nslookup yourdomain.com
```

## Step 3: Install SSL Certificate

On EC2:
```bash
cd /var/www/parkseva
chmod +x setup-ssl.sh
./setup-ssl.sh yourdomain.com your-email@example.com
```

## Step 4: Update Nginx Config

```bash
# Edit nginx-ssl.conf and replace YOUR_DOMAIN
sed -i 's/YOUR_DOMAIN/yourdomain.com/g' nginx-ssl.conf

# Apply SSL config
sudo cp nginx-ssl.conf /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl restart nginx
```

## Step 5: Test HTTPS

Visit: `https://yourdomain.com`

## Auto-Renewal

Certificate auto-renews every 60 days. Check status:
```bash
sudo systemctl status certbot-renew.timer
```

Manual renewal test:
```bash
sudo certbot renew --dry-run
```

## Troubleshooting

### Certificate failed
```bash
# Check if port 80 is accessible
curl http://yourdomain.com

# Check DNS
nslookup yourdomain.com

# Try again
sudo certbot certonly --standalone -d yourdomain.com
```

### Nginx won't start
```bash
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```
