# Stage 1: Build dependencies
FROM python:3.14.4-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2: Runtime image
FROM python:3.14.4-slim AS runtime
WORKDIR /app

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