from pydantic import BaseModel


class QuoteRequest(BaseModel):
    from_currency: str
    to_currency: str
    amount: float
