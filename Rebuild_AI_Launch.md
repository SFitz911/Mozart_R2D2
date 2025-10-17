# Rebuild & Launch Mozart_R2D2 (Vast.ai or Local)

## Full Rebuild & Launch

```bash
git clone https://github.com/SFitz911/Mozart_R2D2.git
cd Mozart_R2D2
cp .env.example .env   # if .env not present
bash bootstrap.sh
make run
```

## Test, Lint, Build, Deploy

```bash
make test      # run tests
make lint      # code quality
make build     # build Docker image
make deploy    # pull + run
```

## Smoke Test

```bash
curl http://localhost:8000/
```

## Notes
- All setup is idempotent; re-running `bootstrap.sh` is safe.
- To destroy/recreate: delete the folder, re-clone, and run the above commands.
- For systemd service, see `scripts/systemd_service_example.service`.
