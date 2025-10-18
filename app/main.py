# app/main.py

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from pathlib import Path
import logging

app = FastAPI(
    title="Mozart_R2D2 API",
    version="1.0.0",
    docs_url=None,      # disable default /docs
    redoc_url=None      # disable redoc
)

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("mozart_r2d2")

# Global error handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled error: {exc}", exc_info=True)
    return JSONResponse(status_code=500, content={"detail": "Internal Server Error"})

# Validation error handler
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.warning(f"Validation error: {exc}")
    return JSONResponse(status_code=422, content={"detail": exc.errors()})


# Basic health route (you already saw this working)
@app.get("/")
def root():
    logger.info("Health check endpoint called.")
    return {"message": "Mozart_R2D2 FastAPI is running!"}

# Serve /static so we can host our custom swagger CSS (use absolute path)
static_dir = Path(__file__).resolve().parent.parent / "static"
app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

# Custom dark-themed Swagger UI
@app.get("/docs", include_in_schema=False)
def custom_swagger_ui():
    return get_swagger_ui_html(
        openapi_url=app.openapi_url,
        title="Mozart_R2D2 — API Docs",
        # Use default JS from CDN (FastAPI fills this automatically)
        # but point CSS to our local override:
        swagger_css_url="/static/swagger-dark.css",
    )
