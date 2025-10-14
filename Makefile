.PHONY: setup run test clean

setup:
	bash bootstrap.sh

run:
	source .venv/bin/activate && python -m app || echo "No app/main.py yet."

test:
	echo "No tests yet."

clean:
	rm -rf .venv __pycache__ *.pyc
