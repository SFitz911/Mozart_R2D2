# Mozart_R2D2 Troubleshooting Guide

## Common Issues & Fixes

### 1. DeepSeek UI not loading
- **Check if DeepSeek is running:**
  - SSH to remote and run: `sudo netstat -tuln | grep 7860`
- **Check logs:**
  - `tail -n 100 /tmp/deepseek_gradio.log`
- **Restart DeepSeek:**
  - `/root/Mozart_R2D2/deploy/deepseek_source/start_deepseek.sh`

### 2. SSH Tunnel not working
- **Correct tunnel command:**
  - `ssh -p 15407 root@148.135.185.20 -L 7860:localhost:7860`
- **Leave tunnel terminal open while using UI.**

### 3. Out of Memory or GPU errors
- **Monitor resources:**
  - `bash scripts/resource_monitor.sh`
- **Restart DeepSeek if needed.**

### 4. Permission denied (publickey)
- **Check SSH key path and permissions.**
- **Use `-i` flag if needed:**
  - `ssh -i /path/to/key -p 15407 root@148.135.185.20`

### 5. .env or secrets exposed
- **Ensure `.env` is in `.gitignore` and not committed.**

---

For more help, check logs, resource usage, and confirm all scripts are up to date.
