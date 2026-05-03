import pytest
from app import app, GenerateRequest
from fastapi.testclient import TestClient

client = TestClient(app)


def test_generate_music_success():
    """Test successful music generation"""
    response = client.post("/generate", json={
        "estilo": "Rock",
        "bpm": 120,
        "descricao": "An energetic rock song with powerful drums"
    })
    assert response.status_code == 200
    data = response.json()
    assert "id" in data
    assert "url" in data
    assert len(data["id"]) > 0


def test_generate_music_invalid_estilo():
    """Test with estilo too short"""
    response = client.post("/generate", json={
        "estilo": "R",
        "bpm": 120,
        "descricao": "An energetic rock song with powerful drums"
    })
    assert response.status_code == 422


def test_generate_music_invalid_bpm():
    """Test with BPM out of range"""
    response = client.post("/generate", json={
        "estilo": "Rock",
        "bpm": 25,
        "descricao": "An energetic rock song with powerful drums"
    })
    assert response.status_code == 422


def test_generate_music_invalid_descricao():
    """Test with description too short"""
    response = client.post("/generate", json={
        "estilo": "Rock",
        "bpm": 120,
        "descricao": "abc"
    })
    assert response.status_code == 422


def test_generate_music_response_format():
    """Test response format"""
    response = client.post("/generate", json={
        "estilo": "Jazz",
        "bpm": 90,
        "descricao": "A smooth jazz piano piece for relaxation"
    })
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data["id"], str)
    assert isinstance(data["url"], str)
    assert "novabeatai.local" in data["url"]
