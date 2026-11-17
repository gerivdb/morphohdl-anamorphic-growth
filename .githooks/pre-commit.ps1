#!/usr/bin/env pwsh
$errs = @()
$pat = 'ghp_[A-Za-z0-9]{36}|gho_[A-Za-z0-9]{36}|AKIA[0-9A-Z]{16}|-----BEGIN[ A-Z]+PRIVATE KEY-----|sk-[A-Za-z0-9]{20,}|xox[bp]-[A-Za-z0-9-]+'
$staged = & git diff --cached --name-only 2>$null
foreach ($f in $staged) {
  if (Test-Path $f) {
    $m = Select-String -Path $f -Pattern $pat -EA SilentlyContinue
    if ($m) { $errs += "SECRET in $f" }
  }
}
foreach ($f in $staged) {
  if (Test-Path $f) {
    $sz = (Get-Item $f).Length
    if ($sz -gt 5MB -and $f -notmatch '\.gitattributes$') { $errs += "LARGE($([math]::Round($sz/1MB,2))MB) $f" }
  }
}
foreach ($f in $staged) { if ($f -match 'node_modules/|\.venv/|__pycache__/') { $errs += "VENDOR $f" } }
foreach ($f in $staged) { if ($f -match '(\.DS_Store|Thumbs\.db|desktop\.ini)$') { $errs += "OS_JUNK $f" } }
if ($errs.Count -gt 0) {
  Write-Host "PRE-COMMIT REJECTED:"
  $errs | ForEach-Object { Write-Host "  $_" }
  exit 1
}
exit 0
