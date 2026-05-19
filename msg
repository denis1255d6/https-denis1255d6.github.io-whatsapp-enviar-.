<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>WhatsApp Quick Send</title>
  <style>
    :root {
      --bg: #0b1020;
      --panel: #111933;
      --panel-soft: #1a264a;
      --accent: #25d366;
      --accent-strong: #16a34a;
      --text: #f2f6ff;
      --muted: #a7b2d8;
      --danger: #ff6464;
      --ring: rgba(37, 211, 102, 0.4);
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      color: var(--text);
      background: radial-gradient(circle at top right, #1b2c5f 0%, var(--bg) 45%);
      display: grid;
      place-items: center;
      padding: 20px;
    }
    .card {
      width: min(680px, 100%);
      background: linear-gradient(180deg, rgba(255, 255, 255, 0.04), rgba(255, 255, 255, 0.01));
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 18px;
      backdrop-filter: blur(10px);
      box-shadow: 0 20px 50px rgba(0, 0, 0, 0.35);
      overflow: hidden;
    }
    .hero {
      padding: 28px;
      background: linear-gradient(135deg, rgba(37, 211, 102, 0.2), rgba(22, 163, 74, 0.08));
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }
    .hero h1 { margin: 0; font-size: clamp(1.4rem, 2.6vw, 2rem); }
    .hero p { margin: 10px 0 0; color: var(--muted); }
    form { padding: 24px; display: grid; gap: 16px; }
    label { font-weight: 600; font-size: 0.95rem; }
    .hint { margin-top: 4px; font-size: .82rem; color: var(--muted); }
    input, textarea {
      width: 100%;
      margin-top: 8px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 12px;
      padding: 12px 14px;
      background: var(--panel);
      color: var(--text);
      outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    input:focus, textarea:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 4px var(--ring);
      background: var(--panel-soft);
    }
    textarea { min-height: 120px; resize: vertical; }
    .actions { display: grid; grid-template-columns: 1fr auto; gap: 12px; }
    .btn {
      border: none;
      border-radius: 12px;
      padding: 12px 18px;
      font-weight: 700;
      cursor: pointer;
      transition: transform .08s ease, filter .2s;
    }
    .btn:active { transform: translateY(1px); }
    .btn-main {
      background: linear-gradient(90deg, var(--accent), var(--accent-strong));
      color: #05210f;
    }
    .btn-alt {
      background: #223057;
      color: var(--text);
      border: 1px solid rgba(255, 255, 255, 0.14);
    }
    .status {
      min-height: 24px;
      font-size: 0.9rem;
      color: var(--muted);
    }
    .status.error { color: var(--danger); }
    .field-error {
      border-color: var(--danger) !important;
      box-shadow: 0 0 0 3px rgba(255, 100, 100, 0.2) !important;
    }
    .footer {
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      padding: 14px 24px;
      color: var(--muted);
      font-size: .82rem;
      background: rgba(0, 0, 0, 0.15);
    }
    @media (max-width: 560px) {
      .actions { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
  <section class="card">
    <header class="hero">
      <h1>Enviar no WhatsApp sem salvar contato</h1>
      <p>Experiência rápida, limpa e sem fricção: informe número + mensagem e abra no WhatsApp em um clique.</p>
    </header>

    <form id="wa-form" novalidate>
      <div>
        <label for="numero">Número com DDI</label>
        <input id="numero" type="tel" placeholder="+55 11 99999-8888" autocomplete="tel" inputmode="tel" aria-describedby="numero-hint status" required />
        <p class="hint" id="numero-hint">Use formato internacional (ex.: +55 para Brasil).</p>
      </div>

      <div>
        <label for="mensagem">Mensagem</label>
        <textarea id="mensagem" placeholder="Digite sua mensagem aqui..." maxlength="500" aria-describedby="mensagem-hint status" required></textarea>
        <p class="hint" id="mensagem-hint">Até 500 caracteres.</p>
      </div>

      <div class="actions">
        <button class="btn btn-main" type="submit">Abrir no WhatsApp</button>
        <button class="btn btn-alt" type="button" id="limpar">Limpar</button>
      </div>

      <div class="status" id="status" role="status" aria-live="polite"></div>
    </form>

    <footer class="footer">
      Dica de UX: você pode colar um número com espaços/símbolos, pois ele será higienizado automaticamente.
    </footer>
  </section>

  <script>
    const form = document.getElementById('wa-form');
    const numeroInput = document.getElementById('numero');
    const mensagemInput = document.getElementById('mensagem');
    const statusEl = document.getElementById('status');
    const limparBtn = document.getElementById('limpar');

    function setStatus(message, isError = false) {
      statusEl.textContent = message;
      statusEl.classList.toggle('error', isError);
    }

    function cleanPhone(phone) {
      return phone.replace(/\D/g, '');
    }
    function isLikelyE164Number(phoneDigits) {
      return phoneDigits.length >= 10 && phoneDigits.length <= 15 && !phoneDigits.startsWith('0');
    }
    function clearFieldErrors() {
      numeroInput.classList.remove('field-error');
      mensagemInput.classList.remove('field-error');
      numeroInput.removeAttribute('aria-invalid');
      mensagemInput.removeAttribute('aria-invalid');
    }

    form.addEventListener('submit', (event) => {
      event.preventDefault();
      clearFieldErrors();
      const numero = numeroInput.value.trim();
      const mensagem = mensagemInput.value.trim();

      if (!numero || !mensagem) {
        if (!numero) {
          numeroInput.classList.add('field-error');
          numeroInput.setAttribute('aria-invalid', 'true');
        }
        if (!mensagem) {
          mensagemInput.classList.add('field-error');
          mensagemInput.setAttribute('aria-invalid', 'true');
        }
        setStatus('Preencha o número e a mensagem para continuar.', true);
        return;
      }

      const numeroLimpo = cleanPhone(numero);
      if (!isLikelyE164Number(numeroLimpo)) {
        numeroInput.classList.add('field-error');
        numeroInput.setAttribute('aria-invalid', 'true');
        setStatus('Número inválido. Use DDI + número (entre 10 e 15 dígitos).', true);
        return;
      }

      const mensagemCodificada = encodeURIComponent(mensagem);
      const link = `https://wa.me/${numeroLimpo}?text=${mensagemCodificada}`;

      setStatus('Abrindo conversa no WhatsApp...');
      window.open(link, '_blank', 'noopener,noreferrer');
    });

    limparBtn.addEventListener('click', () => {
      numeroInput.value = '';
      mensagemInput.value = '';
      setStatus('Campos limpos.');
      numeroInput.focus();
    });
  </script>
</body>
</html>
