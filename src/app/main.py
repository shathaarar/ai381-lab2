
from pathlib import Path
import joblib
import pandas as pd
from fastapi import FastAPI
from pydantic import BaseModel, ConfigDict, Field


# Locate the model file from the project root
PROJECT_ROOT = Path(__file__).resolve().parents[2]
MODEL_PATH = PROJECT_ROOT / "model.joblib"

# Load the model once when the API starts
model = joblib.load(MODEL_PATH)

app = FastAPI(
    title="AI381 Lab 2 Churn Prediction API",
    description="API for predicting customer churn using the V1 model.",
    version="1.0.0",
)


# Define and validate the input data
class ChurnRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    tenure_months: int = Field(ge=0)
    monthly_charges: float = Field(ge=0)
    contract: str = Field(min_length=1)
    internet_service: str = Field(min_length=1)
    support_calls: int = Field(ge=0)


# Define the API response structure
class ChurnResponse(BaseModel):
    churn_prediction: int
    churn_probability: float


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "model_loaded": model is not None,
    }


@app.post("/predict", response_model=ChurnResponse)
def predict(customer: ChurnRequest):
    input_data = pd.DataFrame(
        [customer.model_dump()]
    )

    prediction = int(model.predict(input_data)[0])
    probability = float(model.predict_proba(input_data)[0, 1])

    return ChurnResponse(
        churn_prediction=prediction,
        churn_probability=probability,
    )
