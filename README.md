# Mozart_R2D2

**Purpose:**  
Reproducible, idempotent project skeleton for rapid deployment on Vast.ai Ubuntu 22.04 GPU hosts.

## Quick Start

1. Clone repo to your Vast.ai instance:
   ```bash
   git clone <your-repo-url> Mozart_R2D2
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

4. Run app (replace with your main command as you build):
   ```bash
   make run
   ```

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

## Repo Layout

- `app/` — source code
- `scripts/` — ops helpers
- `bootstrap.sh` — idempotent setup
- `requirements.txt` — Python deps
- `.env.example` — env var template
- `Makefile` — quality-of-life commands
