# Mozart_R2D2

**Purpose:**
Reproducible, idempotent project skeleton for rapid deployment on Vast.ai Ubuntu 22.04 GPU hosts.

## Quick Start

1. Clone repo to your Vast.ai instance:
   ```bash
   git clone https://github.com/SFitz911/Mozart_R2D2.git
   cd Mozart_R2D2
   ```

2. (Optional) Edit `.env`:
   ```bash
   cp .env.example .env
   # Edit .env as needed
   ```

3. Bootstrap environment:
   ```bash
   bash bootstrap.sh
   ```

4. Run app:
   ```bash
   make run
   ```

## Test, Lint, Build, Deploy

- Run tests: `make test`
- Lint code: `make lint`
- Build Docker image: `make build`
- Deploy (pull + run): `make deploy`

## Rebuild Contract

- To destroy/recreate and get running in ≤ 5 min:
  1. `bash bootstrap.sh`
  2. `make run`

## Smoke Test

After running above, verify Python and venv:
```bash
source .venv/bin/activate
python --version
```

## DeepSeek Coder Setup

For running the cloud-based DeepSeek Coder AI assistant:

1. **On a Vast.ai GPU instance** (Ubuntu 22.04, with at least 8GB RAM and a GPU like RTX 3060 or better for performance):
   ```bash
   git clone https://github.com/SFitz911/Mozart_R2D2.git
   cd Mozart_R2D2/deploy
   ```

2. **Bootstrap the DeepSeek environment** (installs Docker, builds the image with the model):
   ```bash
   bash bootstrap_deepseek.sh
   ```
   This may take 10-20 minutes to download the model on first run.

3. **Start the Gradio UI**:
   - Use the VS Code tasks: "Start SSH Tunnel for DeepSeek" and "Relaunch DeepSeek on Remote".
   - Access at `http://localhost:7860` (tunneled from the cloud instance).

4. **Use the interface**: Enter code prompts (e.g., "Write a Python function to reverse a string") to generate code.

### Future: VS Code Integration
The goal is to integrate this cloud-based DeepSeek Coder into VS Code for seamless development assistance. This may involve:
- Exposing an API endpoint from the Gradio app.
- Creating a VS Code extension to query the remote model.
- Handling authentication and real-time communication.

## Repo Layout

- `app/` — source code, FastAPI starter
- `scripts/` — ops helpers (healthcheck, backup, deploy, systemd example)
- `bootstrap.sh` — idempotent setup
- `requirements.txt` — Python deps
- `.env.example` — env var template
- `Makefile` — quality-of-life commands
- `Dockerfile`, `docker-compose.yml` — containerization
- `.github/workflows/ci.yml` — GitHub Actions CI

## Systemd Service Example

See `scripts/systemd_service_example.service` for a template to run as a service.

## GitHub Actions

CI runs lint and tests on every push/PR to `main`.
