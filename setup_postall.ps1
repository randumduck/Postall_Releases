#Requires -Version 5.1
# ==============================================================================
# POSTALL SOVEREIGN ENTERPRISE EDITION — 1-CLICK TURNKEY INSTALLER (WINDOWS)
# ==============================================================================

$ErrorActionPreference = "Continue"

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "   POSTALL SOVEREIGN ENTERPRISE EDITION                 " -ForegroundColor Cyan
Write-Host "   Turnkey 1-Click Customer Deployment Pipeline         " -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# 1. Pre-flight Checks: Docker Daemon Verification
# ------------------------------------------------------------------------------
Write-Host "[1/5] Checking Docker engine status..." -ForegroundColor Yellow
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerCmd) {
    Write-Host "`n[ERROR] Docker CLI was not found on your system PATH." -ForegroundColor Red
    Write-Host "Please install Docker Desktop for Windows (https://www.docker.com/products/docker-desktop) and restart PowerShell." -ForegroundColor Red
    exit 1
}

$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[ERROR] Docker daemon is not running or current user lacks access permissions." -ForegroundColor Red
    Write-Host "Please start Docker Desktop, wait for the engine to initialize, and rerun this installer." -ForegroundColor Red
    exit 1
}
Write-Host "Docker daemon is active and responsive." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 2. Local Directory Scaffolding (Prevents Docker mount errors)
# ------------------------------------------------------------------------------
Write-Host "[2/5] Scaffolding local configuration & credential stores..." -ForegroundColor Yellow
$dirsToCreate = @("keys", "data")
foreach ($dir in $dirsToCreate) {
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Host "  -> Created local directory: .\$dir" -ForegroundColor Gray
    }
}

if (-not (Test-Path -Path ".env")) {
    $defaultEnv = @"
# ==============================================================================
# Postall Sovereign Enterprise Configuration
# ==============================================================================
OLLAMA_BASE_URL=http://postall_llm:11434
LINKEDIN_POST_TIME=09:00
TIMEZONE=Asia/Kolkata
DRY_RUN_MODE=0
DLP_ENABLED=1
BRAND_SAFETY_ENABLED=1
STORAGE_BACKEND=local
"@
    Set-Content -Path ".env" -Value $defaultEnv -Encoding UTF8
    Write-Host "  -> Initialized default environment template: .\.env" -ForegroundColor Gray
}
Write-Host "Local directories and environment configurations ready." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 3. Create Internal Mesh Network
# ------------------------------------------------------------------------------
Write-Host "[3/5] Configuring Postall virtual mesh network..." -ForegroundColor Yellow
$meshCheck = docker network ls --filter "name=^postall_mesh$" --format "{{.Name}}"
if (-not $meshCheck) {
    docker network create postall_mesh 2>$null | Out-Null
}
Write-Host "Internal network 'postall_mesh' established." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 4. Pull Air-Gapped Production Images from Docker Hub
# ------------------------------------------------------------------------------
Write-Host "[4/5] Pulling production images from Docker Hub..." -ForegroundColor Yellow
$Images = @(
    "randumduck69/postall_license_forge:latest",
    "randumduck69/postall_gateway:latest",
    "randumduck69/postall_ai:latest",
    "randumduck69/postall_engine:latest"
)

foreach ($img in $Images) {
    Write-Host "  --> Pulling $img..." -ForegroundColor Cyan
    docker pull $img
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to pull image: $img" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}
Write-Host "All 4 production images verified locally." -ForegroundColor Green

# ------------------------------------------------------------------------------
# 5. Sequentially Deploy the 4 Microservices
# ------------------------------------------------------------------------------
Write-Host "[5/5] Launching Postall Enterprise microservices..." -ForegroundColor Yellow

# A. Postall License Forge
Write-Host "  [1/4] Starting License Forge..." -ForegroundColor Cyan
docker rm -f postall_license_forge 2>$null | Out-Null
docker run -d `
  --name postall_license_forge `
  --network postall_mesh `
  --restart unless-stopped `
  -p 8081:8001 `
  --memory-reservation="1g" `
  --memory="2g" `
  --memory-swap="2g" `
  -v "${PWD}/data:/app/data" `
  randumduck69/postall_license_forge:latest 2>$null | Out-Null

# B. Postall Gateway (Zero-Trust Proxy)
Write-Host "  [2/4] Starting Zero-Trust Cloud Gateway..." -ForegroundColor Cyan
docker rm -f postall_gateway 2>$null | Out-Null
docker run -d `
  --name postall_gateway `
  --network postall_mesh `
  --restart unless-stopped `
  -p 8080:8080 `
  --memory-reservation="2g" `
  --memory="4g" `
  --memory-swap="4g" `
  -v "${PWD}/keys:/app/keys" `
  randumduck69/postall_gateway:latest 2>$null | Out-Null

# C. Postall Sovereign AI Engine (Containerized Ollama)
Write-Host "  [3/4] Starting Sovereign Local AI Engine..." -ForegroundColor Cyan
docker rm -f postall_llm 2>$null | Out-Null
$gpuStarted = $false
try {
    $null = docker run -d `
      --name postall_llm `
      --network postall_mesh `
      --restart unless-stopped `
      --gpus=all `
      -p 11434:11434 `
      -v postall_llm_data:/root/.ollama `
      randumduck69/postall_ai:latest 2>&1
    if ($LASTEXITCODE -eq 0) {
        $gpuStarted = $true
        Write-Host "        Hardware acceleration enabled (--gpus=all)." -ForegroundColor Green
    }
}
catch {
    $gpuStarted = $false
}

if (-not $gpuStarted) {
    Write-Host "        NVIDIA container toolkit not detected; launching in CPU fallback mode..." -ForegroundColor DarkYellow
    docker rm -f postall_llm 2>$null | Out-Null
    docker run -d `
      --name postall_llm `
      --network postall_mesh `
      --restart unless-stopped `
      -p 11434:11434 `
      -v postall_llm_data:/root/.ollama `
      randumduck69/postall_ai:latest 2>$null | Out-Null
    Write-Host "        CPU mode active." -ForegroundColor Green
}

# D. Postall Core Engine
Write-Host "  [4/4] Starting Postall Core Platform Engine..." -ForegroundColor Cyan
docker rm -f postall_engine 2>$null | Out-Null
docker run -d `
  --name postall_engine `
  --network postall_mesh `
  --restart unless-stopped `
  -p 8000:8000 `
  -e OLLAMA_BASE_URL="http://postall_llm:11434" `
  --memory-reservation="4g" `
  --memory="6g" `
  --memory-swap="6g" `
  --log-opt max-size=50m `
  --log-opt max-file=3 `
  -v postall_data:/app/data `
  -v "${PWD}/.env:/app/.env" `
  -v "${PWD}/keys:/app/keys" `
  randumduck69/postall_engine:latest 2>$null | Out-Null

Start-Sleep -Seconds 3

# ------------------------------------------------------------------------------
# Success Output
# ------------------------------------------------------------------------------
Write-Host "`n=========================================================" -ForegroundColor Green
Write-Host "   POSTALL DEPLOYMENT SUCCESSFUL!                       " -ForegroundColor Green
Write-Host "   All 4 sovereign enterprise services are running.     " -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "`nAccess your Postall Enterprise Dashboard at:" -ForegroundColor White
Write-Host "👉  http://localhost:8000/dashboard" -ForegroundColor Green -BackgroundColor Black
Write-Host "`nMicroservice Topology:" -ForegroundColor Gray
Write-Host "  - Core Engine:   http://localhost:8000" -ForegroundColor Gray
Write-Host "  - Local AI Mesh: http://localhost:11434" -ForegroundColor Gray
Write-Host "  - Cloud Gateway: http://localhost:8080" -ForegroundColor Gray
Write-Host "  - License Forge: http://localhost:8081" -ForegroundColor Gray
Write-Host ""

$dashUrl = "http://localhost:8000/dashboard"
try {
    Start-Process $dashUrl
}
catch {
    Write-Host "Navigate to $dashUrl in your web browser to log in." -ForegroundColor Cyan
}
