const request = require('supertest');
const { app, validatePassword } = require('./server');

describe('Password Validation', () => {
  test('rejects password without uppercase', () => {
    expect(validatePassword('password123')).toBe(false);
  });

  test('rejects password without lowercase', () => {
    expect(validatePassword('PASSWORD123')).toBe(false);
  });

  test('rejects password without number', () => {
    expect(validatePassword('PasswordTest')).toBe(false);
  });

  test('rejects password shorter than 8 chars', () => {
    expect(validatePassword('Pass123')).toBe(false);
  });

  test('accepts valid password', () => {
    expect(validatePassword('ValidPass123')).toBe(true);
  });
});

describe('Health Check', () => {
  test('GET /health should respond without error', async () => {
    const response = await request(app).get('/health');
    expect([200, 503]).toContain(response.status);
    expect(response.body).toHaveProperty('status');
  });
});

describe('API Routes', () => {
  test('POST /api/register with invalid email', async () => {
    const response = await request(app)
      .post('/api/register')
      .send({
        email: 'invalid-email',
        password: 'ValidPass123'
      });
    expect(response.status).toBe(400);
  });

  test('POST /api/register with weak password', async () => {
    const response = await request(app)
      .post('/api/register')
      .send({
        email: 'test@example.com',
        password: 'weak'
      });
    expect(response.status).toBe(400);
  });

  test('POST /api/login without credentials', async () => {
    const response = await request(app)
      .post('/api/login')
      .send({});
    expect(response.status).toBe(400);
  });

  test('GET /api/tracks without token', async () => {
    const response = await request(app)
      .get('/api/tracks');
    expect(response.status).toBe(401);
  });
});
