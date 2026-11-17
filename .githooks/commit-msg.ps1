#!/usr/bin/env pwsh
$msgFile = $args[0]
if (-not $msgFile) { exit 0 }
$msg = Get-Content $msgFile -Raw
if ($msg.Length -lt 10) { Write-Host "COMMIT-MSG REJECTED: message trop court (< 10 chars)"; exit 1 }
if ($msg -match '<placeholder>') { Write-Host "COMMIT-MSG REJECTED: placeholder détecté"; exit 1 }
exit 0
