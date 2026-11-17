#!/usr/bin/env pwsh
$args = $args
if ($args -contains '--force') {
  Write-Host "PRE-PUSH REJECTED: --force interdit (utilisez --force-with-lease)"
  exit 1
}
exit 0
