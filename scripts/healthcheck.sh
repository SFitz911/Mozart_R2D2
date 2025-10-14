#!/usr/bin/env bash
set -euo pipefail

curl -fsSL http://localhost:8000/ || echo "Healthcheck failed"
