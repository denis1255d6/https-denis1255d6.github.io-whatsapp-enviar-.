from fastapi import APIRouter
from app.schemas.swap import QuoteRequest
from app.services.ghostswap import get_quote

router = APIRouter(prefix='/swaps', tags=['Swaps'])


@router.post('/quote')
def quote(payload: QuoteRequest):
    return get_quote(
        payload.from_currency,
        payload.to_currency,
        payload.amount,
    )
