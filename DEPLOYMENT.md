# PRISM Framework Website - Deployment Guide

Complete guide for deploying the PRISM Framework website using Docker.

## 🚀 Quick Start

### Prerequisites
- Docker 20.10+ installed
- Docker Compose 2.0+ installed
- 512MB RAM minimum
- Port 8080 available (or customize in docker-compose.yml)

### Local Deployment

```bash
# 1. Clone the repository
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism

# 2. Build and run with Docker Compose
docker-compose up -d

# 3. Access the website
open http://localhost:8080
```

That's it! The website is now running at http://localhost:8080

## 📦 Docker Commands

### Using Docker Compose (Recommended)

```bash
# Build and start
docker-compose up -d

# View logs
docker-compose logs -f website

# Stop services
docker-compose down

# Rebuild after changes
docker-compose up -d --build

# Check health status
docker-compose ps
```

### Using Docker Directly

```bash
# Build image
docker build -t prism-website:2.3.0 .

# Run container
docker run -d \
  --name prism-website \
  -p 8080:80 \
  --restart unless-stopped \
  prism-website:2.3.0

# View logs
docker logs -f prism-website

# Stop container
docker stop prism-website

# Remove container
docker rm prism-website
```

## 🌐 Production Deployment

### Docker Hub Deployment

```bash
# 1. Tag for Docker Hub
docker tag prism-website:2.3.0 yourusername/prism-website:2.3.0
docker tag prism-website:2.3.0 yourusername/prism-website:latest

# 2. Push to Docker Hub
docker push yourusername/prism-website:2.3.0
docker push yourusername/prism-website:latest

# 3. Deploy on production server
docker pull yourusername/prism-website:latest
docker run -d \
  --name prism-website \
  -p 80:80 \
  --restart unless-stopped \
  yourusername/prism-website:latest
```

### AWS ECS Deployment

```bash
# 1. Authenticate to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

# 2. Create ECR repository
aws ecr create-repository --repository-name prism-website

# 3. Tag and push
docker tag prism-website:2.3.0 YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/prism-website:2.3.0
docker push YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/prism-website:2.3.0

# 4. Deploy to ECS (use AWS Console or CLI)
```

### Google Cloud Run Deployment

```bash
# 1. Tag for Google Container Registry
docker tag prism-website:2.3.0 gcr.io/YOUR_PROJECT/prism-website:2.3.0

# 2. Push to GCR
docker push gcr.io/YOUR_PROJECT/prism-website:2.3.0

# 3. Deploy to Cloud Run
gcloud run deploy prism-website \
  --image gcr.io/YOUR_PROJECT/prism-website:2.3.0 \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 80
```

### DigitalOcean App Platform

```bash
# 1. Push to Docker Hub or DigitalOcean Container Registry
docker tag prism-website:2.3.0 registry.digitalocean.com/YOUR_REGISTRY/prism-website:2.3.0
docker push registry.digitalocean.com/YOUR_REGISTRY/prism-website:2.3.0

# 2. Create app via DigitalOcean Console or doctl CLI
doctl apps create --spec .do/app.yaml
```

### Kubernetes Deployment

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prism-website
spec:
  replicas: 3
  selector:
    matchLabels:
      app: prism-website
  template:
    metadata:
      labels:
        app: prism-website
    spec:
      containers:
      - name: website
        image: prism-website:2.3.0
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: prism-website
spec:
  selector:
    app: prism-website
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

```bash
# Deploy to Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check status
kubectl get pods
kubectl get services
```

## 🔧 Configuration

### Environment Variables

```bash
# Set custom port
PORT=3000 docker-compose up -d

# Production mode
NODE_ENV=production docker-compose up -d
```

### Custom Nginx Configuration

Edit `docker/nginx.conf` to customize:
- Security headers
- Gzip compression settings
- Cache policies
- SSL/TLS configuration (for HTTPS)

### Port Customization

Edit `docker-compose.yml`:

```yaml
services:
  website:
    ports:
      - "3000:80"  # Change 3000 to your desired port
```

## 📊 Monitoring & Health Checks

### Health Check Endpoint

```bash
# Check if container is healthy
curl http://localhost:8080/health

# Should return: healthy
```

### Container Health Status

```bash
# Using Docker Compose
docker-compose ps

# Using Docker
docker ps --filter name=prism-website --format "table {{.Names}}\t{{.Status}}"
```

### View Logs

```bash
# Real-time logs
docker-compose logs -f website

# Last 100 lines
docker-compose logs --tail=100 website

# Logs since specific time
docker-compose logs --since 1h website
```

## 🔒 Security Best Practices

### 1. Run as Non-Root User
The Dockerfile already configures this:
```dockerfile
USER nginx
```

### 2. Security Headers
Configured in `docker/nginx.conf`:
- X-Frame-Options
- X-Content-Type-Options
- X-XSS-Protection
- Referrer-Policy

### 3. SSL/TLS Configuration

For HTTPS, add to `docker/nginx.conf`:

```nginx
server {
    listen 443 ssl http2;
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    # ... rest of config
}
```

### 4. Update Docker Image Regularly

```bash
# Pull latest base images
docker-compose build --pull --no-cache

# Update running containers
docker-compose up -d
```

## 🚨 Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs website

# Common issues:
# - Port already in use: Change port in docker-compose.yml
# - Permission denied: Check file permissions
# - Missing files: Verify all files are present
```

### Website Not Accessible

```bash
# 1. Check container is running
docker-compose ps

# 2. Check health status
curl http://localhost:8080/health

# 3. Check Nginx logs
docker-compose logs website | grep error

# 4. Verify port mapping
docker port prism-website
```

### Build Failures

```bash
# Clean build
docker-compose down -v
docker system prune -a
docker-compose up -d --build

# Check Docker disk space
docker system df
```

### Performance Issues

```bash
# Check resource usage
docker stats prism-website

# Increase memory limit in docker-compose.yml:
services:
  website:
    deploy:
      resources:
        limits:
          memory: 512M
```

## 📈 Performance Optimization

### 1. Enable Gzip Compression
Already configured in `docker/nginx.conf`

### 2. Cache Static Assets
Configured with 1-year cache for immutable assets

### 3. Multi-Stage Build
Already implemented in Dockerfile for smaller image size

### 4. Image Size Optimization

```bash
# Check image size
docker images prism-website

# Current size: ~45MB (Alpine-based)
```

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy Website

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build Docker image
        run: docker build -t prism-website:${{ github.sha }} .

      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker tag prism-website:${{ github.sha }} yourusername/prism-website:latest
          docker push yourusername/prism-website:latest
```

## 📋 Maintenance

### Backup Website Content

```bash
# Backup website files
docker cp prism-website:/usr/share/nginx/html ./backup/

# Create backup with timestamp
docker cp prism-website:/usr/share/nginx/html ./backup/website-$(date +%Y%m%d)
```

### Update Website Content

```bash
# 1. Update local files
# 2. Rebuild and redeploy
docker-compose up -d --build
```

### Clean Up Old Images

```bash
# Remove unused images
docker image prune -a

# Remove all stopped containers
docker container prune
```

## 🆘 Support

### Getting Help

- **Documentation**: [README.md](README.md)
- **Issues**: [GitHub Issues](https://github.com/afiffattouh/hildens-prism/issues)
- **Discussions**: [GitHub Discussions](https://github.com/afiffattouh/hildens-prism/discussions)

### Version Information

- **Website Version**: 2.3.0
- **Docker Image**: `prism-website:2.3.0`
- **Base Image**: `nginx:alpine`
- **Nginx Version**: Latest stable (Alpine)

---

**PRISM Framework v2.3.0**
*Enterprise-grade AI context management for Claude Code*

Made with ❤️ by the PRISM Contributors
