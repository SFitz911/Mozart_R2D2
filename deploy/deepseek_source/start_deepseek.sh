#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/demo"

# Activate venv
source ../venv/bin/activate

# Ensure gradio is installed
pip install --upgrade pip
pip install gradio

# Kill any previous DeepSeek/Gradio process
pkill -f app.py || true

# Start the Gradio app (change port if needed)
nohup python app.py --server_name 0.0.0.0 --server_port 7860 > /tmp/deepseek_gradio.log 2>&1 &

echo "DeepSeek is launching. Check /tmp/deepseek_gradio.log for output."
