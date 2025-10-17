#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap_deepseek] starting on $(hostname) at $(date)"

# 0. basic apt
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release git

# 1. install Docker (idempotent)
if ! command -v docker >/dev/null 2>&1; then
  echo "[bootstrap] Installing Docker..."
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER" || true
else
  echo "[bootstrap] Docker already installed"
fi

# 2. Docker Compose plugin (if missing)
if ! docker compose version >/dev/null 2>&1; then
  echo "[bootstrap] Installing docker compose plugin..."
  mkdir -p ~/.docker/cli-plugins
  COMPOSE_VERSION="v2.20.2"
  curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" -o ~/.docker/cli-plugins/docker-compose
  chmod +x ~/.docker/cli-plugins/docker-compose
else
  echo "[bootstrap] docker compose present"
fi

# 3. (Optional) NVIDIA Container Toolkit for GPU passthrough
source .env || true
if [ "${USE_GPU:-false}" = "true" ]; then
  if ! command -v nvidia-smi >/dev/null 2>&1; then
    echo "[bootstrap] Warning: nvidia-smi not found. If you expect GPUs, ensure the provider installed drivers (Vast.ai often does)."
  fi
  if ! docker info | grep -i nvidia >/dev/null 2>&1; then
    echo "[bootstrap] Installing NVIDIA container toolkit..."
    distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update -y
    sudo apt-get install -y nvidia-container-toolkit
    sudo systemctl restart docker
  else
    echo "[bootstrap] nvidia container integration detected"
  fi
fi

# 4. Build local image (if requested) and render final compose
pushd "$(dirname "$0")" >/dev/null
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "[bootstrap] created .env from .env.example - edit values before using in production"
fi

# Load env values
set -a; source .env; set +a

if [ "${USE_LOCAL_BUILD}" = "true" ]; then
  echo "[bootstrap] Building local DeepSeek image: ${IMAGE_NAME}"
  # Build from local source. Expect the DeepSeek source to be copied into ./deepseek_source
  if [ -d ./deepseek_source ]; then
    docker build -t "${IMAGE_NAME}" ./deepseek_source
  else
    echo "[bootstrap] No ./deepseek_source directory found. Please copy your DeepSeek source to deploy/deepseek_source or set USE_LOCAL_BUILD=false." >&2
    exit 1
  fi
else
  echo "[bootstrap] Using prebuilt image: ${AGENT_IMAGE}"
  # write IMAGE_NAME so compose uses AGENT_IMAGE if not building locally
  IMAGE_NAME=${AGENT_IMAGE}
fi

# If GPU requested, generate docker-compose.generated.yml with device_requests
if [ "${USE_GPU}" = "true" ]; then
  cat > docker-compose.generated.yml <<'EOF'
version: "3.9"
services:
  agent:
    image: "${IMAGE_NAME}"
    env_file:
      - .env
    environment:
      - AGENT_API_KEY=${AGENT_API_KEY}
      - AGENT_WORKDIR=${AGENT_WORKDIR}
    volumes:
      - ./agent_data:${AGENT_WORKDIR}
    ports:
      - "${AGENT_PORT}:${AGENT_PORT}"
    restart: unless-stopped
    device_requests:
      - driver: nvidia
        count: -1
        capabilities: [gpu]
  caddy:
    image: caddy:2
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - caddy_data:${CADDY_DATA_DIR}
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
    depends_on:
      - agent
volumes:
  caddy_data:
  agent_data:
EOF
  echo "[bootstrap] created docker-compose.generated.yml with NVIDIA device_requests"
else
  cp docker-compose.yml docker-compose.generated.yml
  echo "[bootstrap] Using standard docker-compose.yml (no GPU device_requests)"
fi

# 5. Bring up stack
echo "[bootstrap] Starting stack with docker compose"
docker compose -f docker-compose.generated.yml up -d

echo "[bootstrap] complete. Use 'docker compose -f docker-compose.generated.yml ps' to view containers."
popd >/dev/null
