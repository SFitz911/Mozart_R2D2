#!/usr/bin/env bash
# Local health check for Mozartv3 FastAPI service via SSH tunnel
set -e
RESPONSE=$(curl -fsSL http://localhost:8080/ || echo "Healthcheck failed")
echo "Healthcheck response: $RESPONSE"
