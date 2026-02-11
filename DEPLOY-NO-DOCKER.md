# Deploy Angular App to AWS EC2 (No Docker)

## Step 1: Launch EC2 Instance

1. Go to AWS Console → EC2 → Launch Instance
2. Choose **Amazon Linux 2023**
3. Instance type: **t2.micro** (free tier)
4. Create/select key pair (download .pem file)
5. Security Group - Allow:
   - SSH (22) - Your IP
   - HTTP (80) - Anywhere
   - HTTPS (443) - Anywhere
6. Launch instance

## Step 2: Connect to EC2

```bash
# Windows (use Git Bash or WSL)
ssh -i "your-key.pem" ec2-user@your-ec2-public-ip

# If permission error on Windows
icacls "your-key.pem" /inheritance:r
icacls "your-key.pem" /grant:r "%username%:R"
```

## Step 3: Install Node.js & Nginx on EC2

```bash
# Update system
sudo yum update -y

# Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Verify
node --version
npm --version

# Install Nginx
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Git
sudo yum install git -y
```

## Step 4: Setup Application Directory

```bash
# Create directory
sudo mkdir -p /var/www/parkseva
sudo chown ec2-user:ec2-user /var/www/parkseva

# Clone repository
cd /var/www/parkseva
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git .

# Make scripts executable
chmod +x deploy-no-docker.sh
```

## Step 5: Configure Nginx

```bash
# Backup default config
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Copy your nginx config
sudo cp /var/www/parkseva/nginx-ec2.conf /etc/nginx/nginx.conf

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

## Step 6: Initial Build & Deploy

```bash
cd /var/www/parkseva
./deploy-no-docker.sh
```

## Step 7: Setup GitHub Actions

1. Go to GitHub repo → Settings → Secrets and variables → Actions
2. Add secrets:
   - **EC2_SSH_KEY**: Paste entire .pem file content
   - **EC2_HOST**: Your EC2 public IP
   - **EC2_USER**: `ec2-user`

## Step 8: Push to GitHub

```bash
git add .
git commit -m "Setup CI/CD"
git push origin main
```

## Verify Deployment

```bash
# Check Nginx status
sudo systemctl status nginx

# View Nginx logs
sudo tail -f /var/log/nginx/error.log

# Check if files exist
ls -la /usr/share/nginx/html/

# Test locally on EC2
curl http://localhost

# Test from browser
http://your-ec2-public-ip
```

## Troubleshooting

### Nginx won't start
```bash
sudo nginx -t
sudo journalctl -u nginx -n 50
```

### Permission issues
```bash
sudo chown -R nginx:nginx /usr/share/nginx/html
sudo chmod -R 755 /usr/share/nginx/html
```

### Build fails
```bash
cd /var/www/parkseva
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Update backend URL
Edit `/etc/nginx/nginx.conf` and change:
```nginx
proxy_pass http://YOUR_BACKEND_IP:3000/api/;
```

Then restart:
```bash
sudo systemctl restart nginx
```

## Auto-Deploy on Git Push

Once GitHub Actions is configured, every push to `main` branch will:
1. SSH into your EC2
2. Pull latest code
3. Build Angular app
4. Deploy to Nginx
5. Restart Nginx

## Manual Deploy Anytime

```bash
ssh -i "your-key.pem" ec2-user@your-ec2-ip
cd /var/www/parkseva
git pull origin main
./deploy-no-docker.sh
```
