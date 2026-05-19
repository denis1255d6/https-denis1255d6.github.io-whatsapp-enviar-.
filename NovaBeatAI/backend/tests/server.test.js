const request = require('supertest');
process.env.NODE_ENV = process.env.NODE_ENV || 'test';
process.env.DATABASE_URL = process.env.DATABASE_URL || 'postgresql://postgres:postgres@127.0.0.1:5432/novabeatai_test';
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test-secret';
const { app, validatePassword } = require('../server');

describe('backend basic checks', () => {
  test('health route', async () => {
    const res = await request(app).get('/health');
    expect([200, 503]).toContain(res.statusCode);
    expect(res.body).toHaveProperty('status');
  });

  test('password policy', () => {
    expect(validatePassword('weak')).toBe(false);
    expect(validatePassword('Strong123')).toBe(true);
  });
});
