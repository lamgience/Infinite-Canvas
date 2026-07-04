param(
    [switch]$NonInteractive
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
$logDir = Join-Path $root "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logPath = Join-Path $logDir ("gemini-cli-install-{0}.log" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
Start-Transcript -Path $logPath -Force | Out-Null

function Pause-End {
    Write-Host ""
    Write-Host "Log: $logPath"
    if (-not $NonInteractive) {
        Read-Host "Press Enter to close"
    }
    Stop-Transcript | Out-Null
}

function Get-NpmCommand {
    $npmCmd = Get-Command npm.cmd -ErrorAction SilentlyContinue
    if ($npmCmd) { return $npmCmd.Source }

    $npm = Get-Command npm -ErrorAction SilentlyContinue
    if ($npm) { return $npm.Source }

    return $null
}

function Add-NpmPrefixToPath {
    param([string]$NpmCommand)

    try {
        $prefix = (& $NpmCommand config get prefix 2>$null | Select-Object -First 1).Trim()
        if ($prefix -and (Test-Path -LiteralPath $prefix)) {
            $env:PATH = "$prefix;$env:PATH"
        }
    } catch {
        Write-Host "Could not read npm global prefix. Continuing with the current PATH."
    }
}

try {
    Write-Host "=== Gemini CLI install/update ==="
    Write-Host "Workspace: $root"
    Write-Host ""

    $npm = Get-NpmCommand
    if (-not $npm) {
        throw "npm was not found. Please install Node.js first, then rerun this installer."
    }

    Write-Host "Installing/updating Gemini CLI with npm: npm install -g @google/gemini-cli"
    & $npm install -g "@google/gemini-cli"
    if ($LASTEXITCODE -ne 0) {
        throw "npm install failed with exit code $LASTEXITCODE."
    }
    Add-NpmPrefixToPath -NpmCommand $npm
    Write-Host ""

    $gemini = Get-Command gemini -ErrorAction SilentlyContinue
    if (-not $gemini) {
        Write-Host "Gemini CLI was installed, but 'gemini' is not available in this PowerShell PATH yet."
        Write-Host "Close this window, open a new PowerShell, then run: gemini"
        Pause-End
        exit 2
    }

    Write-Host "Gemini CLI found: $($gemini.Source)"
    try {
        & gemini --version
    } catch {
        Write-Host "Could not read Gemini version in this session. Open a new PowerShell and run: gemini --version"
    }

    Write-Host ""
    Write-Host "Done. Run 'gemini' in PowerShell to sign in and start using Gemini CLI."
    Write-Host "You can also double-click CLI\windows\gemini\2-start_gemini_cli.bat."
    Pause-End
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Pause-End
    exit 1
}
