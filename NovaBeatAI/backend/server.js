const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
const { Pool } = require('pg');

const app = express();
app.use(helmet());
app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json({ limit: '1mb' }));

app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    return res.json({ status: 'ok', db: 'up' });
  } catch {
    return res.status(503).json({ status: 'degraded', db: 'down' });
  }
});

const DATABASE_URL = process.env.DATABASE_URL;
const JWT_SECRET = process.env.JWT_SECRET;
const FASTAPI_URL = process.env.FASTAPI_URL || 'http://fastapi:8000';

if (!DATABASE_URL) {
  throw new Error('DATABASE_URL is required');
}
if (!JWT_SECRET) {
  throw new Error('JWT_SECRET is required');
}

const pool = new Pool({ connectionString: DATABASE_URL });

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many login attempts. Try again later.' }
});

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
function validatePassword(password) {
  return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(password);
}

function auth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ error: 'Missing token' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

app.post('/api/register', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'email and password are required' });
  if (!emailRegex.test(email)) return res.status(400).json({ error: 'invalid email format' });
  if (!validatePassword(password)) {
    return res.status(400).json({ error: 'password must have 8+ chars, uppercase, lowercase, and number' });
  }

  const hash = await bcrypt.hash(password, 12);
  try {
    const { rows } = await pool.query(
      'INSERT INTO users (email, senha_hash) VALUES ($1, $2) RETURNING id, email',
      [email.toLowerCase(), hash]
    );
    return res.status(201).json(rows[0]);
  } catch (err) {
    if (err.code === '23505') return res.status(409).json({ error: 'email already exists' });
    return res.status(500).json({ error: 'internal error' });
  }
});

app.post('/api/login', loginLimiter, async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'email and password are required' });

  const { rows } = await pool.query('SELECT id, email, senha_hash FROM users WHERE email = $1', [email.toLowerCase()]);
  const user = rows[0];
  if (!user) return res.status(401).json({ error: 'Invalid credentials' });

  const ok = await bcrypt.compare(password, user.senha_hash);
  if (!ok) return res.status(401).json({ error: 'Invalid credentials' });

  const token = jwt.sign({ sub: user.id, email: user.email }, JWT_SECRET, { expiresIn: '1d' });
  return res.json({ token });
});

app.get('/api/tracks', auth, async (req, res) => {
  const { rows } = await pool.query('SELECT id, user_id, nome, estilo, bpm FROM tracks WHERE user_id = $1 ORDER BY id DESC', [req.user.sub]);
  res.json(rows);
});

app.post('/api/tracks', auth, async (req, res) => {
  const { nome, estilo, bpm } = req.body;
  if (!nome || !estilo || !Number.isInteger(bpm) || bpm < 40 || bpm > 300) {
    return res.status(400).json({ error: 'nome, estilo e bpm (40-300) são obrigatórios' });
  }
  const { rows } = await pool.query(
    'INSERT INTO tracks (user_id, nome, estilo, bpm) VALUES ($1, $2, $3, $4) RETURNING id, user_id, nome, estilo, bpm',
    [req.user.sub, nome, estilo, bpm]
  );
  res.status(201).json({ track: rows[0], fastapi_url: `${FASTAPI_URL}/generate` });
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'unexpected error' });
});

if (process.env.NODE_ENV !== 'test') {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`Backend listening on ${PORT}`));
}

module.exports = { app, validatePassword };
