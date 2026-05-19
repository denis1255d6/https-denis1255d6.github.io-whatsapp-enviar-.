# CryptoSwap SaaS

MVP de plataforma de swap de criptomoedas com integração à GhostSwap API.

## Tecnologias
- Backend: FastAPI
- Frontend: Next.js 15
- Banco de dados: Supabase (PostgreSQL)
- Deploy: Railway + Vercel

## Rodando localmente

### Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Linux/macOS
# ou venv\\Scripts\\activate no Windows
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload
```

### Frontend

```bash
cd frontend
npm install
cp .env.local.example .env.local
npm run dev
```

### Banco de Dados

Execute `database/schema.sql` no Supabase.
