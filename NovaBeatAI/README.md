# NovaBeatAI

Projeto full-stack com landing page, backend Express, API FastAPI e PostgreSQL via Docker Compose.

## Estrutura

- `frontend/index.html`: landing page bilíngue com design neon e formulário de inscrição.
- `backend/server.js`: API Node.js com JWT e bcrypt.
- `fastapi/app.py`: endpoint `/generate` para simular geração de faixa.
- `database/schema.sql`: criação das tabelas `users` e `tracks`.
- `docker-compose.yml`: orquestra os serviços `backend`, `fastapi` e `db`.

## Variáveis de ambiente

Copie o arquivo de exemplo:

```bash
cp .env.example .env
# para produção: cp .env.production.example .env.production
```

Variáveis obrigatórias:
- `DATABASE_URL`
- `JWT_SECRET`
- `FASTAPI_URL`


## Começar hoje (rápido)

```bash
cd NovaBeatAI
./start.sh
```

Ou manualmente:

```bash
cp .env.example .env
docker compose up -d --build
```

Depois abra:
- Backend health: `http://localhost:3000/health`
- FastAPI docs: `http://localhost:8000/docs`

## Subir ambiente

```bash
docker compose up --build
```

Serviços expostos:
- Backend: http://localhost:3000
- FastAPI: http://localhost:8000
- PostgreSQL: localhost:5432

## Endpoints backend

- `POST /api/register` `{ "email": "...", "password": "..." }`
- `POST /api/login` `{ "email": "...", "password": "..." }`
- `GET /api/tracks` (Bearer token)
- `POST /api/tracks` (Bearer token)

## Endpoint fastapi

- `POST /generate`
  ```json
  {
    "estilo": "lofi",
    "bpm": 90,
    "descricao": "batida suave com piano"
  }
  ```


## Segurança e produção

- Validação de email no cadastro.
- Política de senha forte (mínimo 8 chars, maiúscula, minúscula e número).
- Hash de senha com bcrypt (cost 12).
- Rate limit no endpoint de login.
- CORS configurável por `CORS_ORIGIN`.

## Testes

Backend:
```bash
cd backend && npm install && npm test
```

FastAPI:
```bash
cd fastapi && pip install -r requirements.txt && pytest
```

## Status de lançamento

Para considerar **lançável em produção**, execute também:

1. Definir `JWT_SECRET` forte e `CORS_ORIGIN` restrito (não usar `*`).
2. Rodar atrás de TLS (Nginx/Cloud Load Balancer) e domínio próprio.
3. Ativar observabilidade (logs centralizados + métricas).
4. Configurar backup do Postgres.
5. Executar testes automatizados em CI antes de deploy.


## CI

Workflow em `.github/workflows/ci.yml` executa:
- `npm test` no backend
- `pytest -q` no serviço FastAPI

## Deploy com Nginx + TLS

### Produção com validação automática

```bash
cp .env.production.example .env.production
./start-prod.sh
```


1. Ajuste domínio em `deploy/nginx/default.conf` (`server_name` e caminhos de certificado).
2. Gere certificado com Certbot no host (`/etc/letsencrypt/live/<dominio>/...`).
3. Crie `.env.production` a partir de `.env.production.example`.
4. Suba stack de produção:

```bash
docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build
```

5. Verifique:

```bash
docker compose -f docker-compose.prod.yml ps
docker compose -f docker-compose.prod.yml logs -f nginx
```

Rotas esperadas:
- `https://<dominio>/api/*` -> backend
- `https://<dominio>/generate` -> fastapi
- `https://<dominio>/` -> landing page estática

## Abrir pasta e rodar automático no VS Code

Este projeto já vem com configuração em `.vscode/tasks.json` para executar `./start.sh` automaticamente ao abrir a pasta (`runOn: folderOpen`).

Passos:
1. Abra a pasta `NovaBeatAI` no VS Code.
2. Quando o VS Code perguntar sobre tarefas automáticas, clique em **Allow Automatic Tasks**.
3. Aguarde o terminal integrado subir os containers.

Arquivos usados:
- `.vscode/tasks.json`
- `.vscode/settings.json`

## Deploy automático (GitHub Actions)

Crie os secrets no GitHub (`Settings > Secrets and variables > Actions`):
- `SSH_HOST`
- `SSH_USER`
- `SSH_KEY` (chave privada)
- `DEPLOY_PATH` (ex: `/opt/novabeatai`)

Workflow: `.github/workflows/deploy.yml`
- Deploy automático em push para `main`
- Deploy manual por `workflow_dispatch`
