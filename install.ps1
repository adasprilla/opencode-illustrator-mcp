#Requires -Version 5.1
# Illustrator MCP - One-Click Installer for OpenCode - UNIVERSAL VERSION
# Migrates old MCP configs instead of deleting them

$ErrorActionPreference = "Stop"

function Get-UserLang {
    try { $c = (Get-Culture).Name; if ($c -like "es*") { return "es" } } catch {}
    return "en"
}
$Lang = Get-UserLang
function Write-Msg($type, $en, $es) {
    $m = if ($Lang -eq "es") { $es } else { $en }
    if ($type -eq "ok") { Write-Host "✓ $m" -ForegroundColor Green }
    elseif ($type -eq "warn") { Write-Host "⚠ $m" -ForegroundColor Yellow }
    elseif ($type -eq "err") { Write-Host "✗ $m" -ForegroundColor Red }
    else { Write-Host $m }
}

Write-Host ""
Write-Msg "info" "Illustrator MCP Installer - Universal" "Instalador Illustrator MCP - Universal"
Write-Host "----------------------------------------"

# Fix ExecutionPolicy
try {
    $p = Get-ExecutionPolicy -Scope CurrentUser
    if ($p -eq "Restricted" -or $p -eq "Undefined") {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    }
} catch {}

# Check Node
function Test-Node {
    try { $a = & node -v 2>$null; $b = & npm.cmd -v 2>$null; if ($a -and $b) { return $true } } catch {}
    return $false
}
if (-not (Test-Node)) {
    Write-Msg "warn" "Node.js not found, trying winget..." "Node.js no encontrado, intentando winget..."
    try {
        winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements -h
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Start-Sleep 3
    } catch {
        Write-Msg "err" "Auto-install failed. Manual: https://nodejs.org/" "Fallo auto-instalacion. Manual: https://nodejs.org/"
        exit 1
    }
}
Write-Msg "ok" "Node $(node -v) / npm $(npm.cmd -v)" "Node $(node -v) / npm $(npm.cmd -v)"

# Install MCP
Write-Msg "info" "Installing illustrator-mcp-server..." "Instalando illustrator-mcp-server..."
npm.cmd install -g illustrator-mcp-server --silent
Write-Msg "ok" "MCP installed" "MCP instalado"

# --- CONFIG - UNIVERSAL MIGRATION LOGIC ---
$configPath = "$env:USERPROFILE\.config\opencode\opencode.json"
$backupPath = "$env:USERPROFILE\.config\opencode\opencode.backup.json"

if (-not (Test-Path (Split-Path $configPath))) { New-Item -ItemType Directory -Path (Split-Path $configPath) -Force | Out-Null }

if (Test-Path $configPath) {
    Copy-Item $configPath $backupPath -Force
    Write-Msg "ok" "Backup: $backupPath" "Respaldo: $backupPath"
    $jsonRaw = Get-Content $configPath -Raw
    if ([string]::IsNullOrWhiteSpace($jsonRaw)) { $jsonRaw = "{}" }
    $existing = $jsonRaw | ConvertFrom-Json
} else {
    $existing = [PSCustomObject]@{ mcp = [PSCustomObject]@{ servers = [PSCustomObject]@{} } }
}

if (-not $existing.mcp) { $existing | Add-Member -NotePropertyName mcp -NotePropertyValue ([PSCustomObject]@{ servers = [PSCustomObject]@{} }) }
if (-not $existing.mcp.servers) { $existing.mcp | Add-Member -NotePropertyName servers -NotePropertyValue ([PSCustomObject]@{} ) -Force }

# MIGRATION: Any property under mcp that is NOT 'servers' and looks like an old MCP config -> migrate to servers
# Old format: mcp.rhino = {type: "local", command: [...], enabled: true}
# New format: mcp.servers.rhino = {type: "local", command: [...]}
$propsToMigrate = @()
foreach ($prop in $existing.mcp.PSObject.Properties) {
    if ($prop.Name -ne "servers" -and $prop.Name -ne "`$schema") {
        # If it has a 'command' or 'type' property, it's an old MCP server
        if ($prop.Value -and ($prop.Value.PSObject.Properties['command'] -or $prop.Value.PSObject.Properties['type'])) {
            $propsToMigrate += $prop.Name
        }
    }
}

foreach ($name in $propsToMigrate) {
    Write-Msg "warn" "Migrating old config: mcp.$name -> mcp.servers.$name" "Migrando config vieja: mcp.$name -> mcp.servers.$name"
    $oldServer = $existing.mcp.$name
    # Clean old props like 'enabled'
    if ($oldServer.PSObject.Properties['enabled']) { $oldServer.PSObject.Properties.Remove('enabled') }
    
    # Only migrate if not already exists in new location (preserve new over old)
    if (-not $existing.mcp.servers.PSObject.Properties[$name]) {
        $existing.mcp.servers | Add-Member -NotePropertyName $name -NotePropertyValue $oldServer -Force
    }
    # Remove old location
    $existing.mcp.PSObject.Properties.Remove($name)
}

# Add/Update illustrator
$existing.mcp.servers | Add-Member -NotePropertyName "illustrator" -NotePropertyValue ([PSCustomObject]@{
    type = "local"
    command = @("npx", "-y", "illustrator-mcp-server")
    environment = [PSCustomObject]@{
        ILLUSTRATOR_MCP_TIMEOUT_NORMAL = "60000"
        ILLUSTRATOR_MCP_TIMEOUT_HEAVY = "180000"
    }
}) -Force

$existing | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
Write-Msg "ok" "Config saved" "Config guardada"

# Verify
try {
    $out = & opencode mcp list 2>&1 | Out-String
    Write-Host $out
} catch {}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
if ($Lang -eq "es") {
    Write-Host "✅ ¡Listo! Illustrator enlazado." -ForegroundColor Green
    Write-Host "Abre Illustrator y corre: opencode -> /mcps" -ForegroundColor White
} else {
    Write-Host "✅ Done! Illustrator linked." -ForegroundColor Green
    Write-Host "Open Illustrator and run: opencode -> /mcps" -ForegroundColor White
}
Write-Host "=================================================" -ForegroundColor Cyan
