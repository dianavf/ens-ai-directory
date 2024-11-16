export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
        <title>ENS AI Directory</title>
      </head>
      <body suppressHydrationWarning={true}>
        {children}
      </body>
    </html>
  );
}
