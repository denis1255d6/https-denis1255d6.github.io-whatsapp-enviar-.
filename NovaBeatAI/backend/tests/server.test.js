const request = require('supertest');
const { app, validatePassword } = require('../server');

describe('backend basic checks', () => {
  test('health route', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('ok');
  });

  test('password policy', () => {
    expect(validatePassword('weak')).toBe(false);
    expect(validatePassword('Strong123')).toBe(true);
  });
});
