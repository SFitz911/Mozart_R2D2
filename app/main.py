# app/main.py
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.openapi.docs import get_swagger_ui_html

app = FastAPI(
    title="Mozart_R2D2 API",
    version="1.0.0",
    docs_url=None,      # disable default /docs
    redoc_url=None      # disable redoc
)

# Basic health route (you already saw this working)
@app.get("/")
def root():
    return {"message": "Mozart_R2D2 FastAPI is running!"}

# Serve /static so we can host our custom swagger CSS
app.mount("/static", StaticFiles(directory="static"), name="static")

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
