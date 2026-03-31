"""CORTEX Backend — FastAPI server for optional AI-powered features."""

from fastapi import FastAPI

from routers.health import router as health_router

app = FastAPI(
    title="CORTEX API",
    description="Backend for CORTEX cognitive training — AI content generation, analytics, sync.",
    version="0.1.0",
)

app.include_router(health_router)


@app.get("/")
async def root() -> dict[str, str]:
    return {"message": "CORTEX API", "version": "0.1.0"}
