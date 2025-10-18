#!/usr/bin/env bash
# Remote helper to start DeepSeek in a tmux session and log to /tmp/deepseek.log
set -e
REPO_DIR="/root/Mozart_R2D2/deploy/deepseek_source"
VENV_PY="$REPO_DIR/venv/bin/python"
LOG_FILE="/tmp/deepseek.log"
SESSION="deepseek"

if [ ! -d "$REPO_DIR" ]; then
  echo "Repo not found at $REPO_DIR"
  exit 1
fi

if [ ! -x "$VENV_PY" ]; then
  echo "Python venv not found or not executable at $VENV_PY"
  exit 1
fi

# Write a small launcher inside /tmp to avoid quoting issues
cat > /tmp/start_deepseek_command.sh <<'EOF'
#!/usr/bin/env bash
REPO_DIR="/root/Mozart_R2D2/deploy/deepseek_source"
VENV_PY="$REPO_DIR/venv/bin/python"
LOG_FILE="/tmp/deepseek.log"
cd "$REPO_DIR"
# kill any previous process listening on 7860 from this repo (best-effort)
pkill -f "demo/app.py" || true
# Start inside tmux so it stays up
if tmux has-session -t deepseek 2>/dev/null; then
  echo "tmux session already exists"
else
  tmux new-session -d -s deepseek "$VENV_PY demo/app.py > $LOG_FILE 2>&1"
  sleep 1
fi
EOF
chmod +x /tmp/start_deepseek_command.sh

# Run the launcher
/bin/bash /tmp/start_deepseek_command.sh

# Print small status
echo "Started tmux session 'deepseek' (if not already running). Log: $LOG_FILE"
ls -l "$LOG_FILE" || true
