.PHONY: setup run test lint build deploy clean

setup:
	bash bootstrap.sh

run:
	source .venv/bin/activate && uvicorn app.main:app --host 0.0.0.0 --port 8000

test:
	source .venv/bin/activate && pytest

lint:
	source .venv/bin/activate && black app && isort app && flake8 app

build:
	docker build -t mozart_r2d2 .

deploy:
	bash scripts/deploy.sh

clean:
	rm -rf .venv __pycache__ *.pyc backup_*.tar.gz
