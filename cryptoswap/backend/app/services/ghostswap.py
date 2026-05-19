import requests
from app.core.config import (
    BASE_URL,
    GHOSTSWAP_PUBLIC_KEY,
    GHOSTSWAP_SECRET,
)


def _headers():
    return {
        'Authorization': (
            f'Bearer {GHOSTSWAP_PUBLIC_KEY}:{GHOSTSWAP_SECRET}'
        )
    }


def get_currencies():
    response = requests.get(
        f'{BASE_URL}/v1/currencies?lite=true',
        headers=_headers(),
        timeout=30,
    )
    response.raise_for_status()
    return response.json()


def get_quote(from_currency: str, to_currency: str, amount: float):
    response = requests.get(
        f'{BASE_URL}/v1/quote',
        params={
            'from': from_currency,
            'to': to_currency,
            'amount': amount,
        },
        headers=_headers(),
        timeout=30,
    )
    response.raise_for_status()
    return response.json()
