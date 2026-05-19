'use client'

import { useState } from 'react'

export default function SwapForm() {
  const [from, setFrom] = useState('btc')
  const [to, setTo] = useState('eth')
  const [amount, setAmount] = useState('0.01')
  const [result, setResult] = useState<any>(null)
  const [loading, setLoading] = useState(false)

  async function handleQuote() {
    setLoading(true)
    setResult(null)

    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL}/swaps/quote`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          from_currency: from,
          to_currency: to,
          amount: Number(amount),
        }),
      }
    )

    const data = await res.json()
    setResult(data)
    setLoading(false)
  }

  return (
    <div>
      <h2>Simular Swap</h2>

      <input value={from} onChange={(e) => setFrom(e.target.value)} placeholder="De" />
      <br /><br />

      <input value={to} onChange={(e) => setTo(e.target.value)} placeholder="Para" />
      <br /><br />

      <input value={amount} onChange={(e) => setAmount(e.target.value)} placeholder="Valor" />
      <br /><br />

      <button onClick={handleQuote} disabled={loading}>
        {loading ? 'Consultando...' : 'Obter Cotação'}
      </button>

      {result && (
        <pre style={{ marginTop: 20, background: '#f4f4f4', padding: 12 }}>
          {JSON.stringify(result, null, 2)}
        </pre>
      )}
    </div>
  )
}
