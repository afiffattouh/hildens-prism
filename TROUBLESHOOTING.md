# PRISM Docker Deployment - Troubleshooting Guide

## Common Issues and Solutions

### 🚨 Bad Gateway (502 Error)

**Symptoms**:
- Browser shows "502 Bad Gateway" or "Bad Gateway" error
- curl returns "502 Bad Gateway"

**Causes & Solutions**:

#### 1. API Proxy Issue (Most Common)

If you see Bad Gateway when accessing `/api/` endpoints:

**Cause**: Nginx is trying to proxy to a non-existent API service.

**Solution**: The API proxy has been commented out in the latest nginx.conf. Rebuild:

```bash
# Stop and remove containers
docker-compose down

# Rebuild with updated config
docker-compose up -d --build

# Verify it's working
curl http://localhost:8080/health
# Should return: healthy
```

#### 2. Container Not Running

**Check if container is running**:
```bash
docker-compose ps
```

**If container is not running**, check logs:
```bash
docker-compose logs website
```

**Solution**:
```bash
# Restart the service
docker-compose restart website

# Or rebuild completely
docker-compose down && docker-compose up -d --build
```

#### 3. Port Conflict

**Cause**: Port 8080 is already in use

**Check**:
```bash
lsof -i :8080
# or
netstat -an | grep 8080
```

**Solution**: Change port in docker-compose.yml:
```yaml
services:
  website:
    ports:
      - "3000:80"  # Change 8080 to any available port
```

### 🐳 Docker Issues

#### Cannot Connect to Docker Daemon

**Error**:
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Solution**:
1. **Start Docker Desktop** (Mac/Windows)
2. Wait for Docker to fully start
3. Verify: `docker ps`

#### Permission Denied

**Error**:
```
permission denied while trying to connect to the Docker daemon socket
```

**Solution** (Linux):
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### 📁 File Not Found Errors

#### Assets/Images Not Loading

**Symptoms**: Logo or images show broken

**Cause**: Assets directory not copied correctly

**Solution**:
```bash
# Check if assets exist in container
docker exec prism-website ls -la /usr/share/nginx/html/assets/

# If missing, rebuild
docker-compose down
docker-compose up -d --build
```

#### 404 for All Pages

**Cause**: Website files not copied

**Check**:
```bash
docker exec prism-website ls -la /usr/share/nginx/html/
```

**Solution**:
```bash
# Ensure website/ directory exists locally
ls -la website/

# Rebuild container
docker-compose up -d --build
```

### ⚙️ Nginx Configuration Issues

#### Config Test Failed

**Check nginx config syntax**:
```bash
# Test config inside container
docker exec prism-website nginx -t

# Or before building
nginx -t -c docker/nginx.conf
```

**Solution**: Fix syntax errors in `docker/nginx.conf`

#### Using Simple Config

If the default config causes issues, use the simplified version:

**Edit Dockerfile** line 27:
```dockerfile
# Change from:
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# To:
COPY docker/nginx-simple.conf /etc/nginx/conf.d/default.conf
```

Then rebuild:
```bash
docker-compose up -d --build
```

### 🔍 Debugging Commands

#### View Real-time Logs
```bash
docker-compose logs -f website
```

#### Enter Container Shell
```bash
docker exec -it prism-website sh
```

#### Check Nginx Error Logs
```bash
docker exec prism-website cat /var/log/nginx/error.log
```

#### Check Container Health
```bash
docker inspect prism-website | grep -A 10 Health
```

#### Test Health Endpoint
```bash
curl http://localhost:8080/health
# Should return: healthy
```

### 🔧 Complete Reset

If nothing else works, perform a complete reset:

```bash
# 1. Stop and remove everything
docker-compose down -v

# 2. Remove images
docker rmi prism-website:2.3.0

# 3. Clean Docker system (optional)
docker system prune -a

# 4. Rebuild from scratch
docker-compose up -d --build

# 5. Check logs
docker-compose logs -f website

# 6. Test health
curl http://localhost:8080/health
```

### 🌐 Accessing the Website

#### Local Development
```bash
# Using docker-compose
http://localhost:8080

# Using custom port (if changed)
http://localhost:YOUR_PORT
```

#### Check What Port Is Actually Used
```bash
docker port prism-website
# Output: 80/tcp -> 0.0.0.0:8080
```

### 📊 Verify Everything Works

Run this checklist:

```bash
# 1. Container is running
docker-compose ps
# Should show: prism-website | running

# 2. Health check passes
curl http://localhost:8080/health
# Should return: healthy

# 3. Main page loads
curl http://localhost:8080/ | grep "PRISM"
# Should return HTML with PRISM

# 4. Assets load
curl -I http://localhost:8080/assets/logo/prism-logo.png
# Should return: 200 OK

# 5. No errors in logs
docker-compose logs website | grep -i error
# Should be empty or minimal
```

### 💡 Quick Fixes Summary

| Problem | Quick Fix |
|---------|-----------|
| Bad Gateway | `docker-compose up -d --build` |
| Container won't start | Check logs: `docker-compose logs website` |
| Port in use | Change port in docker-compose.yml |
| Images broken | Verify assets/ directory exists |
| Config errors | Use nginx-simple.conf |
| Complete failure | Full reset (see above) |

### 🆘 Still Having Issues?

1. **Check validation script**:
   ```bash
   ./scripts/validate-docker-setup.sh
   ```

2. **Collect diagnostics**:
   ```bash
   docker-compose ps > diagnostics.txt
   docker-compose logs website >> diagnostics.txt
   docker inspect prism-website >> diagnostics.txt
   ```

3. **Create GitHub issue** with:
   - Error message
   - Output of diagnostics commands
   - Docker version: `docker --version`
   - OS information

### 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [DEPLOYMENT.md](DEPLOYMENT.md) - Full deployment guide
- [GitHub Issues](https://github.com/afiffattouh/hildens-prism/issues)

---

**PRISM Framework v2.3.0**
