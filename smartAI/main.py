
from typing import List
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from contextlib import asynccontextmanager
import joblib
import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder
import logging
import asyncio

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# Global variables for models
reg_pipeline = None
clf_pipeline = None
term_encoder = None

# Lifespan handler for startup and shutdown
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Load models
    global reg_pipeline, clf_pipeline, term_encoder
    try:
        logger.info("Loading models...")
        reg_pipeline = joblib.load("reg_model_improved.pkl")
        clf_pipeline = joblib.load("clf_model_improved2.pkl")
        term_encoder = LabelEncoder().fit(np.array([12, 24, 36]))
        logger.info("Models loaded successfully")
    except FileNotFoundError as e:
        logger.error(f"Model files not found: {e}")
        raise RuntimeError("Model files 'reg_model_improved.pkl' or 'clf_model_improved.pkl' not found.") from e
    except Exception as e:
        logger.error(f"Error loading models: {e}")
        raise

    yield  # Application runs here

    # Shutdown: Clean up
    logger.info("Shutting down, cleaning up resources...")
    reg_pipeline = None
    clf_pipeline = None
    term_encoder = None
    await asyncio.sleep(0.1)  # Ensure any pending tasks complete

app = FastAPI(title="Loan Recommendation API (Graceful Shutdown)", lifespan=lifespan)

# ----------------------------
# 1. Pydantic Models
# ----------------------------

class UserProfile(BaseModel):
    monthly_income: float = Field(..., gt=0, description="Monthly income in currency")
    annual_income: float = Field(..., gt=0, description="Annual income in currency")
    total_assets: float = Field(..., gt=0, description="Total assets in currency")
    total_expenses: float = Field(..., gt=0, description="Total annual expenses in currency")
    total_taken_loans: float = Field(..., gt=0, description="Total amount of loans taken")
    active_loans: float = Field(..., gt=0, description="Total amount of active loans")
    avg_interest: float = Field(..., gt=0, lt=1, description="Average interest rate as a decimal")
    n_loans: int = Field(..., ge=1, description="Number of loans taken")

class LoanOption(BaseModel):
    name_of_company: str
    interest: float = Field(..., gt=0, lt=1, description="Annual interest rate as a decimal (e.g., 0.15)")
    min_amount: float = Field(..., gt=0, description="Minimum loan amount this product offers")
    max_amount: float = Field(..., gt=0, description="Maximum loan amount this product offers")
    payment_term: int = Field(..., ge=1, description="Payment term in months")

class RecommendedLoan(BaseModel):
    name_of_company: str
    interest: float
    min_amount: float
    max_amount: float
    payment_term: int
    predicted_amount: float
    predicted_term: int
    monthly_payment: float

class RecommendationRequest(BaseModel):
    user_profile: UserProfile
    loan_options: List[LoanOption]

class RecommendationResponse(BaseModel):
    recommendations: List[RecommendedLoan]
    message: str = Field(..., description="Status message")

# ----------------------------
# 2. Helper Function
# ----------------------------

def generate_recommendations(
    user: UserProfile,
    loan_opts: List[LoanOption]
) -> tuple[List[RecommendedLoan], str]:
    """
    1) Compute engineered features and predict recommended_amount and recommended_term.
    2) Compute monthly_payment for all loan options using predicted_amount and their payment_term.
    3) Return all options, sorted by monthly_payment (ascending, best first), with a status message.
    """
    try:
        # (a) Convert user to a single-row DataFrame
        user_dict = user.dict()
        X_user = pd.DataFrame([user_dict])

        # (b) Add engineered features
        X_user["debt_to_income"] = X_user["total_taken_loans"] / X_user["annual_income"]
        X_user["disposable_income"] = X_user["monthly_income"] - X_user["total_expenses"] / 12
        X_user["loan_to_asset"] = X_user["active_loans"] / X_user["total_assets"]

        # (c) Validate input ranges
        if X_user["debt_to_income"].iloc[0] > 10 or X_user["disposable_income"].iloc[0] < 0:
            message = "Invalid user profile: debt_to_income too high or negative disposable_income"
            logger.error(message)
            return [], message

        # (d) Predict loan amount
        pred_amount = float(reg_pipeline.predict(X_user)[0])
        if pred_amount < 100:
            message = f"Predicted amount {pred_amount:.2f} is too low"
            logger.warning(message)
            return [], message
        logger.info(f"Predicted amount: {pred_amount}")

        # (e) Predict loan term
        pred_term_enc = int(clf_pipeline.predict(X_user)[0])
        pred_term = int(term_encoder.inverse_transform([pred_term_enc])[0])
        logger.info(f"Predicted term: {pred_term}")

        # (f) Build a DataFrame of all provided loan options
        df_opts = pd.DataFrame([opt.dict() for opt in loan_opts])

        # (g) Compute monthly payment for each option
        df_opts["predicted_amount"] = round(pred_amount, 0)
        df_opts["predicted_term"] = pred_term
        df_opts["monthly_payment"] = df_opts.apply(
            lambda row: round(
                pred_amount * (row["interest"] / 12) / (1 - (1 + row["interest"] / 12) ** -row["payment_term"]), 0
            ),
            axis=1
        )

        # (h) Sort by monthly_payment (ascending)
        df_opts = df_opts.sort_values(by="monthly_payment", ascending=True).reset_index(drop=True)

        # (i) Convert to RecommendedLoan models
        recs: List[RecommendedLoan] = []
        for _, row in df_opts.iterrows():
            rec = RecommendedLoan(
                name_of_company=row["name_of_company"],
                interest=row["interest"],
                min_amount=row["min_amount"],
                max_amount=row["max_amount"],
                payment_term=int(row["payment_term"]),
                predicted_amount=float(row["predicted_amount"]),
                predicted_term=int(row["predicted_term"]),
                monthly_payment=float(row["monthly_payment"])
            )
            recs.append(rec)

        message = f"Returned {len(recs)} loan options, sorted by monthly payment (best first)"
        logger.info(message)
        return recs, message

    except Exception as e:
        message = f"Error processing recommendations: {str(e)}"
        logger.error(message)
        return [], message

# ----------------------------
# 3. API Endpoint
# ----------------------------

@app.post("/recommend_loan_all", response_model=RecommendationResponse)
async def recommend_loan_all(req: RecommendationRequest):
    # Validate loan options
    if not req.loan_options:
        raise HTTPException(status_code=400, detail="loan_options list cannot be empty")

    recommendations, message = generate_recommendations(req.user_profile, req.loan_options)
    return RecommendationResponse(recommendations=recommendations, message=message)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
