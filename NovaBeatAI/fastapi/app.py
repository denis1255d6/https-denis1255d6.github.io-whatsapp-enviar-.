from fastapi import FastAPI
from pydantic import BaseModel, Field
from uuid import uuid4

app = FastAPI(title="NovaBeatAI Generator API")


class GenerateRequest(BaseModel):
    estilo: str = Field(..., min_length=2, max_length=60)
    bpm: int = Field(..., ge=40, le=300)
    descricao: str = Field(..., min_length=5, max_length=500)


class GenerateResponse(BaseModel):
    id: str
    url: str


@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "ok", "service": "fastapi"}


@app.post('/generate', response_model=GenerateResponse)
def generate_music(payload: GenerateRequest):
    """Generate music based on style, BPM and description"""
    music_id = str(uuid4())
    return {
        'id': music_id,
        'url': f'https://cdn.novabeatai.local/tracks/{music_id}.mp3'
    }
