# AI381 Lab 2 – MLOps Churn Prediction API

![CI/CD](https://github.com/shathaarar/ai381-lab2/actions/workflows/ci.yml/badge.svg)

A machine learning API that predicts customer churn using a trained Scikit-learn model. This project demonstrates an end-to-end MLOps workflow, including model training, API development, automated testing, Docker containerization, security scanning, and continuous integration and deployment.

## Project Overview

The API receives customer information and returns:
- A churn prediction (`0` or `1`).
- The probability of customer churn.

The model is trained using the V1 churn dataset and a Scikit-learn pipeline.

## Technologies Used

- Python 3.14
- Scikit-learn
- Pandas
- FastAPI
- Pydantic
- Pytest
- Ruff
- Docker
- GitHub Actions
- Trivy
- GitHub Container Registry (GHCR)

## Project Structure

```text
lab2/
├── data/
│   └── churn_v1.csv
├── src/
│   ├── train/
│   │   └── train.py
│   └── app/
│       └── main.py
├── tests/
│   └── test_api.py
├── model.joblib
├── requirements.txt
├── Dockerfile
├── .dockerignore
└── .github/
    └── workflows/
        └── ci.yml
```

## Getting Started

### Run with Docker

Make sure Docker is installed and running.

Clone the repository:

```bash
git clone https://github.com/shathaarar/ai381-lab2.git
cd ai381-lab2
```

Build and run the application with one command:

```bash
docker build -t ai381-lab2 . && docker run --rm -p 8000:8000 ai381-lab2
```

The API will be available at:

`http://localhost:8000`

### API Documentation

FastAPI provides interactive API documentation at:

`http://localhost:8000/docs`

### Available Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/health` | Checks API health and model loading status. |
| POST | `/predict` | Predicts customer churn. |

### Prediction Example

**Request:**

```json
{
  "tenure_months": 12,
  "monthly_charges": 75.5,
  "contract": "Month-to-month",
  "internet_service": "Fiber optic",
  "support_calls": 3
}
```

**Response:**

```json
{
  "churn_prediction": 1,
  "churn_probability": 0.72
}
```

The response values above are illustrative.

## Testing and Code Quality

Run the tests locally:

```bash
python -m pytest -v
```

Run code quality checks:

```bash
ruff check src tests
```

The project includes five automated tests covering:
- API endpoint contracts.
- Model loading.
- Input validation.
- Unknown categorical values.
- Deterministic predictions.

## CI/CD Pipeline

GitHub Actions automates the project workflow.

**On every Pull Request to `main`:**
1. Install project dependencies.
2. Run Ruff lint checks.
3. Run Pytest.

**On pushes to `main`:**
1. Build the Docker image.
2. Scan the image using Trivy.
3. Push the image to GitHub Container Registry (GHCR), tagged with the commit SHA.

The `main` branch is protected by a ruleset requiring Pull Requests and successful `Lint and Test` checks before merging.

## Container Registry

Docker images are published to:

`ghcr.io/shathaarar/ai381-lab2`

Each published image is tagged with its corresponding Git commit SHA.

## Author

**Shatha Arar**

AI381 – MLOps Lab 2
