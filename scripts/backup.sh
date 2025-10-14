#!/usr/bin/env bash
set -euo pipefail

tar czf backup_$(date +%Y%m%d_%H%M%S).tar.gz app scripts requirements.txt .env || echo "Backup failed"
