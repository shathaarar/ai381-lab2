# Stage 1: Build dependencies
FROM python:3.14-slim@sha256:cd89c30eda26ee911a4611b18680086e0ea42e6f5f8cbe653d07fa7958c9cec8 AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2: Runtime image
FROM python:3.14-slim@sha256:cd89c30eda26ee911a4611b18680086e0ea42e6f5f8cbe653d07fa7958c9cec8 AS runtime
WORKDIR /app

# Update operating system packages to include security fixes
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies from the builder stage
COPY --from=builder /install /usr/local

# Copy application files
COPY src/ ./src/
COPY model.joblib .

# Create a non-root user
RUN useradd --create-home appuser && \
    chown -R appuser:appuser /app

USER appuser
EXPOSE 8000

# Check whether the API is healthy
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=3)" || exit 1

# Start the API
CMD ["uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000"]