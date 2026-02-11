# Quick Deploy Commands

## First Time Setup (On EC2)
```bash
# Connect
ssh -i "your-key.pem" ec2-user@YOUR_EC2_IP

# Install everything
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs nginx git
sudo systemctl start nginx && sudo systemctl enable nginx

# Setup app
sudo mkdir -p /var/www/parkseva
sudo chown ec2-user:ec2-user /var/www/parkseva
cd /var/www/parkseva
git clone YOUR_GITHUB_REPO_URL .
chmod +x deploy-no-docker.sh

# Configure Nginx
sudo cp nginx-ec2.conf /etc/nginx/nginx.conf
# Edit backend URL: sudo nano /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl restart nginx

# Deploy
./deploy-no-docker.sh
```

## Update Backend URL
```bash
sudo nano /etc/nginx/nginx.conf
# Change: proxy_pass http://YOUR_BACKEND_IP:3000/api/;
sudo systemctl restart nginx
```

## Manual Deploy
```bash
ssh -i "your-key.pem" ec2-user@YOUR_EC2_IP
cd /var/www/parkseva
git pull origin main
./deploy-no-docker.sh
```

## Troubleshoot
```bash
# Check Nginx
sudo systemctl status nginx
sudo nginx -t
sudo tail -f /var/log/nginx/error.log

# Check files
ls -la /usr/share/nginx/html/

# Rebuild
cd /var/www/parkseva
rm -rf node_modules
npm install
npm run build
```

## GitHub Secrets
- EC2_SSH_KEY: Content of .pem file
- EC2_HOST: EC2 public IP
- EC2_USER: ec2-user
