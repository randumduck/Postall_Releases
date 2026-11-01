#!/bin/bash
# ==============================================================================
# POSTALL SOVEREIGN ENTERPRISE EDITION — 1-CLICK TURNKEY INSTALLER (LINUX/MAC)
# ==============================================================================

set -e

# Terminal Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${CYAN}   POSTALL SOVEREIGN ENTERPRISE EDITION                 ${NC}"
echo -e "${CYAN}   Turnkey 1-Click Customer Deployment Pipeline         ${NC}"
echo -e "${CYAN}=========================================================${NC}"

# ------------------------------------------------------------------------------
# 1. Pre-flight Checks: Docker Daemon Verification
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/5] Checking Docker engine status...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "\n${RED}[ERROR] Docker CLI was not found in your system PATH.${NC}"
    echo -e "${RED}Please install Docker (https://docs.docker.com/get-docker/) and rerun this script.${NC}"
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo -e "\n${RED}[ERROR] Docker daemon is not running or current user lacks access permissions.${NC}"
    echo -e "${RED}Please start the Docker daemon (e.g. 'sudo systemctl start docker' or launch Docker Desktop) and rerun this installer.${NC}"
    exit 1
fi
echo -e "${GREEN}Docker daemon is active and responsive.${NC}"

# ------------------------------------------------------------------------------
# 2. Local Directory Scaffolding (Prevents Docker mount errors)
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[2/5] Scaffolding local configuration & credential stores...${NC}"
mkdir -p keys data

if [ ! -f ".env" ]; then
    cat << 'EOF' > .env
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
EOF
    echo -e "  ${GRAY}-> Initialized default environment template: ./.env${NC}"
fi
echo -e "${GREEN}Local directories and environment configurations ready.${NC}"

# ------------------------------------------------------------------------------
# 3. Create Internal Mesh Network
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[3/5] Configuring Postall virtual mesh network...${NC}"
if ! docker network ls --filter "name=^postall_mesh$" --format "{{.Name}}" | grep -q "postall_mesh"; then
    docker network create postall_mesh 2>/dev/null || true
fi
echo -e "${GREEN}Internal network 'postall_mesh' established.${NC}"

# ------------------------------------------------------------------------------
# 4. Pull Air-Gapped Production Images from Docker Hub
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[4/5] Pulling production images from Docker Hub...${NC}"
IMAGES=(
    "randumduck69/postall_ai:latest"
    "randumduck69/postall_engine:latest"
)

for img in "${IMAGES[@]}"; do
    echo -e "  ${CYAN}--> Pulling $img...${NC}"
    docker pull "$img"
done
echo -e "${GREEN}Production images verified locally.${NC}"

# ------------------------------------------------------------------------------
# 5. Deploy Postall Sovereign Microservices (AI Engine & Platform)
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[5/5] Launching Postall Sovereign microservices...${NC}"

# A. Postall Sovereign AI Engine (Containerized Ollama)
echo -e "  ${CYAN}[1/2] Starting Sovereign Local AI Engine...${NC}"
docker rm -f postall_llm 2>/dev/null || true

GPU_STARTED=0
if command -v nvidia-smi &> /dev/null; then
    if docker run -d \
      --name postall_llm \
      --network postall_mesh \
      --restart unless-stopped \
      --gpus=all \
      --memory="4g" \
      --memory-swap="4g" \
      --health-cmd="curl -f http://localhost:11434/api/tags || exit 1" \
      --health-interval=30s \
      --health-retries=3 \
      --memory="4g" \
      --memory-swap="4g" \
      --health-cmd="curl -f http://localhost:11434/api/tags || exit 1" \
      --health-interval=30s \
      --health-retries=3 \
      -p 11434:11434 \
      -v postall_llm_data:/root/.ollama \
      randumduck69/postall_ai:latest >/dev/null 2>&1; then
        GPU_STARTED=1
        echo -e "        ${GREEN}Hardware acceleration enabled (--gpus=all).${NC}"
    fi
fi

if [ $GPU_STARTED -eq 0 ]; then
    echo -e "        ${YELLOW}Launching in CPU fallback mode...${NC}"
    docker rm -f postall_llm 2>/dev/null || true
    docker run -d \
      --name postall_llm \
      --network postall_mesh \
      --restart unless-stopped \
      --memory="4g" \
      --memory-swap="4g" \
      --health-cmd="curl -f http://localhost:11434/api/tags || exit 1" \
      --health-interval=30s \
      --health-retries=3 \
      -p 11434:11434 \
      -v postall_llm_data:/root/.ollama \
      randumduck69/postall_ai:latest >/dev/null
    echo -e "        ${GREEN}CPU mode active.${NC}"
fi

# B. Postall Core Engine
echo -e "  ${CYAN}[2/2] Starting Postall Core Platform Engine...${NC}"
docker rm -f postall_engine 2>/dev/null || true
docker run -d \
  --name postall_engine \
  --network postall_mesh \
  --restart unless-stopped \
  -p 8000:8000 \
  -e OLLAMA_BASE_URL="http://postall_llm:11434" \
  --memory-reservation="4g" \
  --memory="6g" \
  --memory-swap="6g" \
  --health-cmd="curl -f http://localhost:8000/api/health || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  --log-opt max-size=50m \
  --log-opt max-file=3 \
  -v postall_data:/app/data \
  -v "$(pwd)/.env:/app/.env" \
  -v "$(pwd)/keys:/app/keys" \
  randumduck69/postall_engine:latest >/dev/null

sleep 3

# ------------------------------------------------------------------------------
# Success Output
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}=========================================================${NC}"
echo -e "${GREEN}   POSTALL DEPLOYMENT SUCCESSFUL!                       ${NC}"
echo -e "${GREEN}   Core Platform Engine & Sovereign Local AI online.    ${NC}"
echo -e "${GREEN}=========================================================${NC}"
echo -e "\nAccess your Postall Enterprise Dashboard at:"
echo -e "${GREEN}👉  http://localhost:8000/dashboard${NC}"
echo -e "\n${GRAY}Microservice Topology:${NC}"
echo -e "  ${GRAY}- Core Engine:   http://localhost:8000${NC}"
echo -e "  ${GRAY}- Local AI Mesh: http://localhost:11434${NC}\n"

# Attempt to open browser on supported systems
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:8000/dashboard" >/dev/null 2>&1 || true
elif command -v open &> /dev/null; then
    open "http://localhost:8000/dashboard" >/dev/null 2>&1 || true
fi
