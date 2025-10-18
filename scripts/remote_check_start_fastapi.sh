#!/usr/bin/env bash
# Remote script to check and start FastAPI on port 8080
set -e
APP_DIR="/root/Mozart_R2D2/app"
VENV_DIR="/root/Mozart_R2D2/.venv"
PORT=8080

if ! sudo lsof -i :$PORT | grep LISTEN; then
  echo "No service listening on port $PORT. Starting FastAPI..."
  cd "$APP_DIR"
  source "$VENV_DIR/bin/activate"
  nohup uvicorn main:app --host 0.0.0.0 --port $PORT > /tmp/fastapi.log 2>&1 &
  sleep 2
  if sudo lsof -i :$PORT | grep LISTEN; then
    echo "FastAPI started successfully on port $PORT."
  else
    echo "Failed to start FastAPI on port $PORT. Check /tmp/fastapi.log."
  fi
else
  echo "Service already running on port $PORT."
fi
