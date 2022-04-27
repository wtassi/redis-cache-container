$openssl = "${env:ProgramFiles}\Git\usr\bin\openssl.exe"
$env:path = "$env:path;${env:ProgramFiles}\Git\usr\bin"

# Altere aqui o path conforme desejado.
$outputPath = $pwd.Path + "\tls"

if (!(Test-Path -Path $outputPath)) {
  New-Item -ItemType Directory -Force -Path $outputPath -Confirm:$false
}

function generate_cert {
  [CmdletBinding()]
  param (
    [String]$name,
    [String]$cn,
    [String]$options
  )
  
  begin {
    $certRequest = $outputPath + "\$name.csr"
    $certFile = $outputPath + "\$name.crt"
    $keyFile = $outputPath + "\$name.key"    
  }

  process {
    # .key
    openssl genrsa -out "$keyFile" 2048

    # *.csr
    openssl req `
      -new -sha256 `
      -subj "/O=Redis/CN=$cn" `
      -key "$keyfile" `
      -out "$certRequest"

    # *.crt
    openssl x509 `
      -req -sha256 `
      -in "$certRequest" `
      -CA "$outputPath\ca.crt" `
      -CAkey "$outputPath\ca.key" `
      -CAserial "$outputPath\ca.txt" `
      -CAcreateserial `
      -days 365 `
      -out "$certfile" `
      "$opts"

  }
}
# Certificate CA
if(!(Test-Path -Path "$outputPath\ca.key" )) {

  # ca.key
  do {
    openssl genrsa -out "$outputPath\ca.key" 4096
    $response = (Test-Path -Path "$outputPath\ca.key")
  } while (!$response)
  
  # ca.crt
  do {
    openssl req `
    -x509 `
    -new `
    -nodes `
    -sha256 `
    -key "$outputPath\ca.key" `
    -days 3650 `
    -subj "/O=Redis/CN=Redis Local Certificate Authority" `
    -out "$outputPath\ca.crt"
    $response = (Test-Path -Path "$outputPath\ca.crt")
  } while (!$response)
  
}
  # openssl.cnf
  if (Test-Path -Path "$outputPath\openssl.cnf") {
    Remove-Item -Path "$outputPath\openssl.cnf" -Force
  }
  do {
    $openssl_cnf = "$outputPath\openssl.cnf"
    Add-Content -Path $openssl_cnf -Value "[server_cert]"
    Add-Content -Path $openssl_cnf -Value "basicConstraints = CA:FALSE"
    Add-Content -Path $openssl_cnf -Value "keyUsage = digitalSignature, keyEncipherment"
    Add-Content -Path $openssl_cnf -Value "nsCertType = server"
    Add-Content -Path $openssl_cnf -Value "[client_cert]"
    Add-Content -Path $openssl_cnf -Value "keyUsage = digitalSignature, keyEncipherment"
    Add-Content -Path $openssl_cnf -Value "nsCertType = client"
  $response = (Test-Path -Path "$outputPath\openssl.cnf")
} while (!$response)

generate_cert -name "server" -cn "Redis-Server-Only" -options "-extensions 'server_cert' -extfile $outputPath\openssl.cnf"
generate_cert -name "client" -cn "Redis-Client-Only" -options "-extensions 'client_cert' -extfile $outputPath\openssl.cnf"
generate_cert -name "redis" -cn "Redis-Generic-cert"

# redis.dh
do {
  openssl dhparam -out "$outputPath\redis.dh" 2048
  $response = (Test-Path -Path "$outputPath\redis.dh")
} while (!$response)

Write-Host -ForegroundColor Yellow "Certified Generated."
(Get-ChildItem -Path $outputPath).Name

Remove-Item -Path "$outputPath" -Include "*.csr" -Recurse

# Ouput esperado:
#   - ca.crt
#   - ca.key
#   - ca.txt
#   - client.crt
#   - client.key
#   - openssl.cnf
#   - redis.crt
#   - redis.dh
#   - redis.key
#   - server.crt
#   - server.key