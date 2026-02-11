# AWS EC2 Deployment Setup

## 1. EC2 Instance Setup

### Launch EC2 Instance
- AMI: Amazon Linux 2023
- Instance Type: t2.micro (or larger)
- Security Group: Allow ports 22 (SSH), 80 (HTTP), 443 (HTTPS)

### Connect to EC2
```bash
ssh -i your-key.pem ec2-user@your-ec2-ip
```

## 2. Install Dependencies

```bash
# Update system
sudo yum update -y

# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install Git
sudo yum install git -y

# Logout and login again for docker group to take effect
exit
```

## 3. Clone Repository

```bash
# Create app directory
sudo mkdir -p /var/www/parkseva
sudo chown ec2-user:ec2-user /var/www/parkseva

# Clone repo
cd /var/www/parkseva
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git .

# Make deploy script executable
chmod +x deploy.sh
```

## 4. GitHub Secrets Configuration

Add these secrets in GitHub: Settings → Secrets → Actions

- `EC2_SSH_KEY`: Your EC2 private key content
- `EC2_HOST`: Your EC2 public IP or domain
- `EC2_USER`: `ec2-user`

## 5. Initial Deployment

```bash
cd /var/www/parkseva
./deploy.sh
```

## 6. Configure Domain (Optional)

### Install Nginx for SSL
```bash
sudo yum install nginx certbot python3-certbot-nginx -y
```

### Get SSL Certificate
```bash
sudo certbot --nginx -d yourdomain.com
```

## 7. Environment Variables

Update `nginx.conf` backend proxy URL:
```nginx
proxy_pass http://YOUR_BACKEND_IP:3000/api/;
```

## Verify Deployment

```bash
# Check container status
docker ps

# View logs
docker logs parkseva-frontend

# Test application
curl http://localhost
```

## Troubleshooting

```bash
# Restart container
docker restart parkseva-frontend

# View nginx logs
docker exec parkseva-frontend cat /var/log/nginx/error.log

# Rebuild
docker build --no-cache -t parkseva-frontend .
```
