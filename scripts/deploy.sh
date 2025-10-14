#!/usr/bin/env bash
set -euo pipefail

git pull origin main
bash bootstrap.sh
make run
