<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Enviar WhatsApp sem salvar contato</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f2f2f2;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .container {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      width: 100%;
      max-width: 400px;
    }

    input, textarea, button {
      width: 100%;
      padding: 12px;
      margin-top: 10px;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 16px;
    }

    button {
      background-color: #25D366;
      color: white;
      border: none;
      cursor: pointer;
      transition: background 0.3s;
    }

    button:hover {
      background-color: #1ebc5a;
    }
  </style>
</head>
<body>

  <div class="container">
    <h2>Enviar mensagem via WhatsApp</h2>
    <label for="numero">Número com DDI (ex: +5511999998888):</label>
    <input type="text" id="numero" placeholder="+5511999998888" />

    <label for="mensagem">Mensagem:</label>
    <textarea id="mensagem" rows="4" placeholder="Digite sua mensagem..."></textarea>

    <button onclick="enviarMensagem()">Enviar para WhatsApp</button>
  </div>

  <script>
    function enviarMensagem() {
      const numero = document.getElementById('numero').value.trim();
      const mensagem = document.getElementById('mensagem').value.trim();

      if (!numero || !mensagem) {
        alert("Preencha o número e a mensagem.");
        return;
      }

      const numeroLimpo = numero.replace(/[^0-9]/g, '');
      const mensagemCodificada = encodeURIComponent(mensagem);

      const link = `https://wa.me/${numeroLimpo}?text=${mensagemCodificada}`;
      window.open(link, '_blank');
    }
  </script>

</body>
</html>
