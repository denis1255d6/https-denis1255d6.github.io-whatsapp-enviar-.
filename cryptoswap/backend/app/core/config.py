import os
from dotenv import load_dotenv

load_dotenv()

APP_NAME = os.getenv('APP_NAME', 'CryptoSwap API')
GHOSTSWAP_PUBLIC_KEY = os.getenv('GHOSTSWAP_PUBLIC_KEY', '')
GHOSTSWAP_SECRET = os.getenv('GHOSTSWAP_SECRET', '')
BASE_URL = 'https://partners-api.ghostswap.io'
