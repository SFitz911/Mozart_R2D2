#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap] starting on $(hostname) at $(date)"
sudo apt-get update -y

sudo apt-get install -y build-essential git curl unzip wget python3 python3-venv python3-pip

if command -v nvidia-smi >/dev/null 2>&1; then
  echo "[bootstrap] GPU detected:"
  nvidia-smi || true
else
  echo "[bootstrap] No nvidia-smi found (CPU-only or driver not exposed). Continuing..."
fi

if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi
source .venv/bin/activate
pip install --upgrade pip wheel

if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
fi

if command -v node >/dev/null 2>&1; then
  echo "[bootstrap] Node present: $(node -v)"
else
  echo "[bootstrap] Installing Node LTS..."
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

if [ ! -f ".env" ] && [ -f ".env.example" ]; then
  cp .env.example .env
  echo "[bootstrap] Created .env from .env.example (edit values as needed)."
fi

echo "[bootstrap] complete."
