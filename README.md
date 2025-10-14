
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
