$root = "C:\Users\shestov\Desktop\cloude - code - test"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Serving $root on http://localhost:8080/"
while ($listener.IsListening) {
  $context = $listener.GetContext()
  $path = $context.Request.Url.LocalPath.TrimStart('/')
  if ([string]::IsNullOrEmpty($path)) { $path = "tetris.html" }
  $file = Join-Path $root $path
  if (Test-Path $file -PathType Leaf) {
    $bytes = [System.IO.File]::ReadAllBytes($file)
    if ($file -match '\.html$') { $context.Response.ContentType = "text/html; charset=utf-8" }
    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $context.Response.StatusCode = 404
  }
  $context.Response.Close()
}
