#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "Erro: Docker não encontrado. Instale Docker Desktop/Engine e tente novamente."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Erro: Docker Compose plugin não encontrado."
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Arquivo .env criado a partir de .env.example"
fi

echo "Subindo NovaBeatAI..."
docker compose up -d --build

echo "OK. Serviços:"
echo "- Frontend: abra NovaBeatAI/frontend/index.html no navegador"
echo "- Backend: http://localhost:3000/health"
echo "- FastAPI: http://localhost:8000/docs"
