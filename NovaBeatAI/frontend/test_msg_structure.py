from pathlib import Path
import re

html = Path('msg').read_text(encoding='utf-8')

def assert_contains(snippet: str, label: str):
    if snippet not in html:
        raise AssertionError(f'Missing {label}: {snippet}')

# Core accessibility and UX structure checks
assert_contains('id="wa-form"', 'form id')
assert_contains('id="numero"', 'phone input')
assert_contains('id="mensagem"', 'message textarea')
assert_contains('role="status"', 'status role')
assert_contains('aria-live="polite"', 'status live region')
assert_contains('required', 'required fields')
assert_contains('maxlength="500"', 'message maxlength')
assert_contains('function cleanPhone(phone)', 'cleanPhone function')
assert_contains('function isLikelyE164Number(phoneDigits)', 'phone validation function')
assert_contains("window.open(link, '_blank', 'noopener,noreferrer')", 'safe window.open')

# Make sure wa.me link pattern is present in JS
if not re.search(r"https://wa\.me/\$\{numeroLimpo\}\?text=\$\{mensagemCodificada\}", html):
    raise AssertionError('Missing expected wa.me URL template')

print('msg structure checks passed')
