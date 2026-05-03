# Deployment Guide - NovaBeatAI

## Prerequisites
- Docker & Docker Compose installed
- PostgreSQL 15+
- Node.js 20+
- Python 3.11+

## Local Development

### 1. Clone and Setup
```bash
git clone <repository>
cd NovaBeatAI
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your local values
```

### 3. Run with Docker Compose
```bash
docker-compose up -d
```

This will start:
- **PostgreSQL Database** on port 5432
- **FastAPI Server** on port 8000 (http://localhost:8000/docs)
- **Node.js Backend** on port 3000 (http://localhost:3000/health)

### 4. Test the Services
```bash
# Backend health check
curl http://localhost:3000/health

# FastAPI docs
open http://localhost:8000/docs

# Register user
curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123"}'
```

## Production Deployment

### 1. Prepare Production Secrets
Create `.env.production` with production values:
```bash
# Copy template
cp .env.production.example .env.production

# Edit with real credentials
# ⚠️ NEVER commit .env.production to version control
```

### 2. GitHub Actions Secrets
Add to your repository secrets (`Settings > Secrets and variables > Actions`):
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - Strong random string (32+ chars)
- `DOCKER_REGISTRY_USERNAME` - GitHub Container Registry username
- `DOCKER_REGISTRY_PASSWORD` - GitHub token with write permissions

### 3. Deploy with Docker
```bash
docker-compose -f docker-compose.yml up -d
```

### 4. Database Migrations
```bash
# Run schema initialization
docker exec novabeatai-db psql -U postgres -d novabeatai -f /docker-entrypoint-initdb.d/schema.sql
```

### 5. Verify Deployment
```bash
# Check all services are healthy
docker-compose ps

# View logs
docker-compose logs -f backend
docker-compose logs -f fastapi
docker-compose logs -f db
```

## CI/CD Pipeline

The GitHub Actions workflow automatically:
1. Runs tests on every push and PR
2. Builds Docker images
3. Pushes to GitHub Container Registry
4. Tags images with commit SHA and 'latest'

### Monitoring Images
```bash
# Pull images from registry
docker pull ghcr.io/<owner>/backend:latest
docker pull ghcr.io/<owner>/fastapi:latest
```

## Health Checks

All services have health check endpoints:

| Service | Endpoint | Command |
|---------|----------|---------|
| Backend | GET /health | `curl http://localhost:3000/health` |
| FastAPI | GET /health | `curl http://localhost:8000/health` |
| Database | pg_isready | `docker exec novabeatai-db pg_isready` |

## Troubleshooting

### Database Connection Errors
```bash
# Check PostgreSQL is running
docker exec novabeatai-db pg_isready

# View PostgreSQL logs
docker-compose logs db
```

### Backend Crashes
```bash
# Check backend logs
docker-compose logs -f backend

# Verify JWT_SECRET is set
docker exec novabeatai-backend env | grep JWT_SECRET
```

### FastAPI Not Starting
```bash
# Check FastAPI logs
docker-compose logs -f fastapi

# Verify Python environment
docker exec novabeatai-fastapi python --version
```

## Security Checklist
- [ ] JWT_SECRET is strong (32+ random chars)
- [ ] DATABASE_URL uses encrypted password
- [ ] CORS_ORIGIN is set to your domain
- [ ] .env files are in .gitignore
- [ ] GitHub secrets are configured
- [ ] SSL/TLS certificates are configured
- [ ] Rate limiting is enabled (already in backend)
- [ ] Helmet.js is enabled (already in backend)

## Scaling

### Horizontal Scaling
```bash
# Run multiple backend instances
docker-compose up -d --scale backend=3
```

### Reverse Proxy (Nginx example)
```nginx
upstream backend {
    server backend:3000;
}

server {
    listen 80;
    server_name api.novabeatai.com;

    location /api {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Support
For issues or questions, create an issue on GitHub.
