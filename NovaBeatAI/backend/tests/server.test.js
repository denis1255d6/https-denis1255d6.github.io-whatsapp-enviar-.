process.env.NODE_ENV = 'test';
process.env.DATABASE_URL = process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/novabeatai';
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test-secret';

const request = require('supertest');
const { app, validatePassword } = require('../server');

describe('backend basic checks', () => {
  test('health route returns 200 or 503 depending on db status', async () => {
    const res = await request(app).get('/health');
    expect([200, 503]).toContain(res.statusCode);
  });

  test('password policy', () => {
    expect(validatePassword('weak')).toBe(false);
    expect(validatePassword('Strong123')).toBe(true);
  });
});
