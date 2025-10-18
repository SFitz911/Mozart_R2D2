#!/usr/bin/env bash
# Resource monitoring script for GPU, RAM, and disk
set -e

echo "==== GPU Usage ===="
nvidia-smi || echo "No GPU found."

echo "\n==== RAM Usage ===="
free -h

echo "\n==== Disk Usage ===="
df -h /
