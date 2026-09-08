# Production Dockerfile for MediPlant AI Backend (FastAPI + TensorFlow)
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000 \
    VERIFICATION_THRESHOLD=0.85

# Set work directory
WORKDIR /app

# Install system dependencies needed for Pillow and TensorFlow
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy and install python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy backend application code and trained model weights
COPY . .

# Expose port (FastAPI default or Cloud dynamic PORT)
EXPOSE 8000

# Healthcheck to ensure container is responsive
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:${PORT}/ || exit 1

# Start Uvicorn bound to dynamic cloud $PORT or default 8000
CMD exec uvicorn app:app --host 0.0.0.0 --port ${PORT:-8000}
