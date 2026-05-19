export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="pt-BR">
      <body style={{ fontFamily: 'Arial, sans-serif', margin: 0, padding: 20 }}>
        {children}
      </body>
    </html>
  )
}
