#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "Erro: Docker não encontrado."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Erro: Docker Compose plugin não encontrado."
  exit 1
fi

if [ ! -f .env.production ]; then
  echo "Erro: .env.production não encontrado."
  echo "Crie com: cp .env.production.example .env.production"
  exit 1
fi

required=(DATABASE_URL JWT_SECRET FASTAPI_URL CORS_ORIGIN POSTGRES_DB POSTGRES_USER POSTGRES_PASSWORD)
for key in "${required[@]}"; do
  if ! grep -qE "^${key}=.+" .env.production; then
    echo "Erro: variável obrigatória ausente em .env.production -> ${key}"
    exit 1
  fi
done

echo "Subindo stack de produção..."
docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build

echo "Deploy iniciado com sucesso."
docker compose -f docker-compose.prod.yml ps
