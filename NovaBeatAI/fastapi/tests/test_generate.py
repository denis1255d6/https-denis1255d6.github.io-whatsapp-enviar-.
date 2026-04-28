from fastapi.testclient import TestClient
from app import app

client = TestClient(app)

def test_generate_success():
    response = client.post('/generate', json={
        'estilo': 'lofi',
        'bpm': 95,
        'descricao': 'batida leve com piano'
    })
    assert response.status_code == 200
    payload = response.json()
    assert 'id' in payload
    assert payload['url'].startswith('https://')


def test_generate_invalid_bpm():
    response = client.post('/generate', json={
        'estilo': 'lofi',
        'bpm': 10,
        'descricao': 'x' * 10
    })
    assert response.status_code == 422
