from fastapi import FastAPI
from app.core.config import APP_NAME
from app.routes import currencies, swaps

app = FastAPI(title=APP_NAME)


@app.get('/')
def root():
    return {'message': 'CryptoSwap API Online'}


app.include_router(currencies.router)
app.include_router(swaps.router)
