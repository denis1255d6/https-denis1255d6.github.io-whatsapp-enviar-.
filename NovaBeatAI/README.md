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
