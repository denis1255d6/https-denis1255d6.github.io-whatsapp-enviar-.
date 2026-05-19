from fastapi import APIRouter
from app.services.ghostswap import get_currencies

router = APIRouter(prefix='/currencies', tags=['Currencies'])


@router.get('/')
def list_currencies():
    return get_currencies()
