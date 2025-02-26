# === Stage 1: Builder ===
FROM public.ecr.aws/docker/library/python:3.13-slim AS builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN apt update && apt install -y python3-pip && \
    pip install --no-cache-dir -r requirements.txt --target /dependencies

# === Stage 2: Final Image ===
FROM public.ecr.aws/docker/library/python:3.13-slim

WORKDIR /app

# Copy dependencies from builder stage
COPY --from=builder /dependencies /usr/local/lib/python3.13/site-packages

# Copy application files
COPY app.py .

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
