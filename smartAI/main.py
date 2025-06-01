# # fastapi_app.py

# from typing import List, Optional
# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel, Field
# import joblib
# import numpy as np
# import pandas as pd
# from sklearn.preprocessing import LabelEncoder

# app = FastAPI(title="Loan Recommendation API")

# # ----------------------------
# # 1. Pydantic Models
# # ----------------------------

# class UserProfile(BaseModel):
#     monthly_income: float
#     annual_income: float
#     total_assets: float
#     total_expenses: float
#     total_taken_loans: float
#     active_loans: float
#     avg_interest: float
#     n_loans: int


# class LoanOption(BaseModel):
#     name_of_company: str
#     interest: float = Field(..., gt=0, lt=1, description="Annual interest rate (decimal, e.g. 0.15 for 15%)")
#     min_amount: float = Field(..., gt=0, description="Minimum loan amount allowed")
#     max_amount: float = Field(..., gt=0, description="Maximum loan amount allowed")
#     payment_term: int = Field(..., description="Payment term in months")


# class RecommendedLoan(BaseModel):
#     name_of_company: str
#     interest: float
#     min_amount: float
#     max_amount: float
#     payment_term: int
#     predicted_amount: float
#     predicted_term: int
#     monthly_payment: float


# class RecommendationRequest(BaseModel):
#     user_profile: UserProfile
#     loan_options: List[LoanOption]


# class RecommendationResponse(BaseModel):
#     recommendations: List[RecommendedLoan]


# # ----------------------------
# # 2. Load Pre‐trained Models on Startup
# # ----------------------------

# try:
#     reg_pipeline = joblib.load("reg_model.pkl")
#     clf_pipeline = joblib.load("clf_model.pkl")
# except FileNotFoundError as e:
#     # If these files do not exist, the app will not start. Ensure you run the training
#     # and saving procedure first so that reg_model.pkl and clf_model.pkl are present.
#     raise RuntimeError("Model files not found. Please ensure 'reg_model.pkl' and 'clf_model.pkl' exist.") from e

# # Recreate the same LabelEncoder for repayment terms we used during training
# term_encoder = LabelEncoder().fit(np.array([6, 12, 24, 36]))


# # ----------------------------
# # 3. Helper Function
# # ----------------------------

# def generate_recommendations(
#     user: UserProfile,
#     loan_opts: List[LoanOption]
# ) -> List[RecommendedLoan]:
#     """
#     Given a single user's financial profile and a list of loan products,
#     predict the recommended loan amount and term, filter the loan options,
#     compute monthly payments, sort ascending by monthly_payment, and return
#     the sorted list.
#     """
#     # Convert user profile to a single-row DataFrame
#     user_dict = user.dict()
#     X_user = pd.DataFrame([user_dict])

#     # During training we used one‐hot columns for "recommended_loan_option_loan_1"
#     # through "recommended_loan_option_loan_5" (loan_0 was dropped). For prediction,
#     # set all these dummy columns = 0.
#     for i in range(1, 6):
#         X_user[f"recommended_loan_option_loan_{i}"] = 0

#     # 1) Predict recommended_amount using the regression pipeline
#     pred_amount = float(reg_pipeline.predict(X_user)[0])

#     # 2) Predict recommended_term using the classification pipeline
#     pred_term_enc = int(clf_pipeline.predict(X_user)[0])
#     pred_term = int(term_encoder.inverse_transform([pred_term_enc])[0])

#     # 3) Filter loan options by matching term AND amount range
#     df_opts = pd.DataFrame([opt.dict() for opt in loan_opts])
#     candidates = df_opts[
#         (df_opts["payment_term"] == pred_term) &
#         (df_opts["min_amount"] <= pred_amount) &
#         (df_opts["max_amount"] >= pred_amount)
#     ].copy()

#     # If no loan satisfies both criteria, fall back to "term only"
#     if candidates.empty:
#         candidates = df_opts[df_opts["payment_term"] == pred_term].copy()

#     # 4) Compute a simple monthly payment for each candidate:
#     #    monthly_payment = (pred_amount * (1 + user.avg_interest)) / pred_term
#     monthly_payment = (pred_amount * (1 + user.avg_interest)) / pred_term
#     candidates["predicted_amount"] = round(pred_amount, 0)
#     candidates["predicted_term"] = pred_term
#     candidates["monthly_payment"] = round(monthly_payment, 0)

#     # 5) Sort ascending by monthly_payment (best‐deal first)
#     candidates = candidates.sort_values(by="monthly_payment", ascending=True).reset_index(drop=True)

#     # 6) Build and return List[RecommendedLoan]
#     recs: List[RecommendedLoan] = []
#     for _, row in candidates.iterrows():
#         rec = RecommendedLoan(
#             name_of_company=row["name_of_company"],
#             interest=row["interest"],
#             min_amount=row["min_amount"],
#             max_amount=row["max_amount"],
#             payment_term=int(row["payment_term"]),
#             predicted_amount=float(row["predicted_amount"]),
#             predicted_term=int(row["predicted_term"]),
#             monthly_payment=float(row["monthly_payment"])
#         )
#         recs.append(rec)

#     return recs


# # ----------------------------
# # 4. API Endpoint
# # ----------------------------

# @app.post("/recommend_loans", response_model=RecommendationResponse)
# def recommend_loans(req: RecommendationRequest):
#     # Validate that loan_options is non-empty
#     if not req.loan_options:
#         raise HTTPException(status_code=400, detail="loan_options list cannot be empty")

#     recommendations = generate_recommendations(req.user_profile, req.loan_options)
#     return RecommendationResponse(recommendations=recommendations)

# fastapi_app_filtered.py

# from typing import List
# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel, Field
# import joblib
# import numpy as np
# import pandas as pd
# from sklearn.preprocessing import LabelEncoder

# app = FastAPI(title="Loan Recommendation API (Filtered)")

# # ----------------------------
# # 1. Pydantic Models
# # ----------------------------

# class UserProfile(BaseModel):
#     monthly_income: float
#     annual_income: float
#     total_assets: float
#     total_expenses: float
#     total_taken_loans: float
#     active_loans: float
#     avg_interest: float
#     n_loans: int


# class LoanOption(BaseModel):
#     name_of_company: str
#     interest: float = Field(..., gt=0, lt=1, description="Annual interest rate as a decimal (e.g. 0.15)")
#     min_amount: float = Field(..., gt=0, description="Minimum loan amount this product offers")
#     max_amount: float = Field(..., gt=0, description="Maximum loan amount this product offers")
#     payment_term: int = Field(..., description="Payment term in months")


# class RecommendedLoan(BaseModel):
#     name_of_company: str
#     interest: float
#     min_amount: float
#     max_amount: float
#     payment_term: int
#     predicted_amount: float
#     predicted_term: int
#     monthly_payment: float


# class RecommendationRequest(BaseModel):
#     user_profile: UserProfile
#     loan_options: List[LoanOption]


# class RecommendationResponse(BaseModel):
#     recommendations: List[RecommendedLoan]


# # ----------------------------
# # 2. Load Pre‑trained Models
# # ----------------------------

# try:
#     reg_pipeline = joblib.load("reg_model.pkl")
#     clf_pipeline = joblib.load("clf_model.pkl")
# except FileNotFoundError as e:
#     raise RuntimeError("Model files not found. Please ensure 'reg_model.pkl' and 'clf_model.pkl' exist.") from e

# # Recreate the exact LabelEncoder used during training
# term_encoder = LabelEncoder().fit(np.array([6, 12, 24, 36]))


# # ----------------------------
# # 3. Helper Function (Filtered)
# # ----------------------------

# def generate_filtered_recommendations(
#     user: UserProfile,
#     loan_opts: List[LoanOption]
# ) -> List[RecommendedLoan]:
#     """
#     1) Predict a recommended_amount and recommended_term for this user.
#     2) Only keep those loan options whose payment_term == recommended_term
#        AND whose min_amount <= recommended_amount <= max_amount.
#     3) Compute a monthly_payment score for each.
#     4) Return the filtered list, sorted ascending by monthly_payment. 
#     """

#     # (a) Convert user to a single-row DataFrame for the pipelines
#     user_dict = user.dict()
#     X_user = pd.DataFrame([user_dict])

#     # Add the dummy columns that were used during training (loan_1..loan_5 = 0)
#     for i in range(1, 6):
#         X_user[f"recommended_loan_option_loan_{i}"] = 0

#     # (b) Predict loan amount
#     pred_amount = float(reg_pipeline.predict(X_user)[0])

#     # (c) Predict loan term (encoded → decode)
#     pred_term_enc = int(clf_pipeline.predict(X_user)[0])
#     pred_term = int(term_encoder.inverse_transform([pred_term_enc])[0])

#     # (d) Build a DataFrame of the provided loan options
#     df_opts = pd.DataFrame([opt.dict() for opt in loan_opts])

#     # (e) Filter to options matching BOTH predicted_term AND predicted_amount range
#     candidates = df_opts[
#         (df_opts["payment_term"] == pred_term) &
#         (df_opts["min_amount"] <= pred_amount) &
#         (df_opts["max_amount"] >= pred_amount)
#     ].copy()

#     # If none match both criteria, return an empty list (or you could raise an error).
#     if candidates.empty:
#         return []

#     # (f) Compute a simple monthly payment for each candidate:
#     #     monthly_payment = (pred_amount * (1 + user.avg_interest)) / pred_term
#     monthly_payment = (pred_amount * (1 + user.avg_interest)) / pred_term
#     candidates["predicted_amount"] = round(pred_amount, 0)
#     candidates["predicted_term"] = pred_term
#     candidates["monthly_payment"] = round(monthly_payment, 0)

#     # (g) Sort ascending by monthly_payment (best deal first)
#     candidates = candidates.sort_values(by="monthly_payment", ascending=True).reset_index(drop=True)

#     # (h) Convert each row into a RecommendedLoan model
#     recs: List[RecommendedLoan] = []
#     for _, row in candidates.iterrows():
#         rec = RecommendedLoan(
#             name_of_company=row["name_of_company"],
#             interest=row["interest"],
#             min_amount=row["min_amount"],
#             max_amount=row["max_amount"],
#             payment_term=int(row["payment_term"]),
#             predicted_amount=float(row["predicted_amount"]),
#             predicted_term=int(row["predicted_term"]),
#             monthly_payment=float(row["monthly_payment"])
#         )
#         recs.append(rec)

#     return recs


# # ----------------------------
# # 4. API Endpoint (Filtered)
# # ----------------------------

# @app.post("/recommend_loans_filtered", response_model=RecommendationResponse)
# def recommend_loans_filtered(req: RecommendationRequest):
#     # Ensure we have at least one loan option
#     if not req.loan_options:
#         raise HTTPException(status_code=400, detail="loan_options list cannot be empty")

#     recommendations = generate_filtered_recommendations(req.user_profile, req.loan_options)
#     if not recommendations:
#         # You could return an empty list, or raise an HTTP 404 / 204. Here we return empty.
#         return RecommendationResponse(recommendations=[])

#     return RecommendationResponse(recommendations=recommendations)
# from typing import List
# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel, Field
# import joblib
# import numpy as np
# import pandas as pd
# from sklearn.preprocessing import LabelEncoder
# import logging

# # Set up logging
# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# app = FastAPI(title="Loan Recommendation API (Sorted Predictions)")

# # ----------------------------
# # 1. Pydantic Models
# # ----------------------------

# class UserProfile(BaseModel):
#     monthly_income: float = Field(..., gt=0, description="Monthly income in currency")
#     annual_income: float = Field(..., gt=0, description="Annual income in currency")
#     total_assets: float = Field(..., gt=0, description="Total assets in currency")
#     total_expenses: float = Field(..., gt=0, description="Total annual expenses in currency")
#     total_taken_loans: float = Field(..., gt=0, description="Total amount of loans taken")
#     active_loans: float = Field(..., gt=0, description="Total amount of active loans")
#     avg_interest: float = Field(..., gt=0, lt=1, description="Average interest rate as a decimal")
#     n_loans: int = Field(..., ge=1, description="Number of loans taken")

# class LoanOption(BaseModel):
#     name_of_company: str
#     interest: float = Field(..., gt=0, lt=1, description="Annual interest rate as a decimal (e.g., 0.15)")
#     min_amount: float = Field(..., gt=0, description="Minimum loan amount this product offers")
#     max_amount: float = Field(..., gt=0, description="Maximum loan amount this product offers")
#     payment_term: int = Field(..., ge=1, description="Payment term in months")

# class RecommendedLoan(BaseModel):
#     name_of_company: str
#     interest: float
#     min_amount: float
#     max_amount: float
#     payment_term: int
#     predicted_amount: float
#     predicted_term: int
#     monthly_payment: float

# class RecommendationRequest(BaseModel):
#     user_profile: UserProfile
#     loan_options: List[LoanOption]

# class RecommendationResponse(BaseModel):
#     recommendations: List[RecommendedLoan]
#     message: str = Field(..., description="Status or reason for empty recommendations")

# # ----------------------------
# # 2. Load Pre-trained Models
# # ----------------------------

# try:
#     reg_pipeline = joblib.load("reg_model_improved.pkl")
#     clf_pipeline = joblib.load("clf_model_improved.pkl")
# except FileNotFoundError as e:
#     raise RuntimeError("Model files 'reg_model_improved.pkl' or 'clf_model_improved.pkl' not found.") from e

# # Recreate the LabelEncoder used during training
# term_encoder = LabelEncoder().fit(np.array([12, 24, 36]))

# # ----------------------------
# # 3. Helper Function
# # ----------------------------

# def generate_filtered_recommendations(
#     user: UserProfile,
#     loan_opts: List[LoanOption]
# ) -> tuple[List[RecommendedLoan], str]:
#     """
#     1) Compute engineered features and predict recommended_amount and recommended_term.
#     2) Filter loan options where payment_term == predicted_term and min_amount <= predicted_amount <= max_amount.
#     3) Compute monthly_payment using amortization formula.
#     4) Return all matching options, sorted by monthly_payment (ascending, best first), with a status message.
#     """
#     # (a) Convert user to a single-row DataFrame
#     user_dict = user.dict()
#     X_user = pd.DataFrame([user_dict])

#     # (b) Add engineered features (same as in training)
#     X_user["debt_to_income"] = X_user["total_taken_loans"] / X_user["annual_income"]
#     X_user["disposable_income"] = X_user["monthly_income"] - X_user["total_expenses"] / 12
#     X_user["loan_to_asset"] = X_user["active_loans"] / X_user["total_assets"]

#     # (c) Validate input ranges
#     if X_user["debt_to_income"].iloc[0] > 10 or X_user["disposable_income"].iloc[0] < 0:
#         message = "Invalid user profile: debt_to_income too high or negative disposable_income"
#         logger.error(message)
#         return [], message

#     # (d) Predict loan amount
#     pred_amount = float(reg_pipeline.predict(X_user)[0])
#     if pred_amount <= 0:
#         message = f"Invalid predicted amount: {pred_amount}"
#         logger.error(message)
#         return [], message
#     logger.info(f"Predicted amount: {pred_amount}")

#     # (e) Predict loan term (encoded → decode)
#     pred_term_enc = int(clf_pipeline.predict(X_user)[0])
#     pred_term = int(term_encoder.inverse_transform([pred_term_enc])[0])
#     logger.info(f"Predicted term: {pred_term}")

#     # (f) Build a DataFrame of the provided loan options
#     df_opts = pd.DataFrame([opt.dict() for opt in loan_opts])

#     # (g) Filter to options matching predicted_term and amount range
#     candidates = df_opts[
#         (df_opts["payment_term"] == pred_term) &
#         (df_opts["min_amount"] <= pred_amount) &
#         (df_opts["max_amount"] >= pred_amount)
#     ].copy()

#     # (h) Check if any candidates match
#     if candidates.empty:
#         message = f"No loan options match predicted term ({pred_term} months) and amount ({pred_amount:.2f})"
#         logger.info(message)
#         return [], message

#     # (i) Compute monthly payment using amortization formula
#     candidates["predicted_amount"] = round(pred_amount, 0)
#     candidates["predicted_term"] = pred_term
#     candidates["monthly_payment"] = candidates.apply(
#         lambda row: round(
#             pred_amount * (row["interest"] / 12) / (1 - (1 + row["interest"] / 12) ** -pred_term), 0
#         ),
#         axis=1
#     )

#     # (j) Sort by monthly_payment (ascending) to put best option first
#     candidates = candidates.sort_values(by="monthly_payment", ascending=True).reset_index(drop=True)

#     # (k) Convert to RecommendedLoan models
#     recs: List[RecommendedLoan] = []
#     for _, row in candidates.iterrows():
#         rec = RecommendedLoan(
#             name_of_company=row["name_of_company"],
#             interest=row["interest"],
#             min_amount=row["min_amount"],
#             max_amount=row["max_amount"],
#             payment_term=int(row["payment_term"]),
#             predicted_amount=float(row["predicted_amount"]),
#             predicted_term=int(row["predicted_term"]),
#             monthly_payment=float(row["monthly_payment"])
#         )
#         recs.append(rec)

#     message = f"Found {len(recs)} matching loan options, sorted by monthly payment (best first)"
#     logger.info(message)
#     return recs, message

# # ----------------------------
# # 4. API Endpoint
# # ----------------------------

# @app.post("/recommend_loans_filtered", response_model=RecommendationResponse)
# async def recommend_loans_filtered(req: RecommendationRequest):
#     # Validate loan options
#     if not req.loan_options:
#         raise HTTPException(status_code=400, detail="loan_options list cannot be empty")

#     recommendations, message = generate_filtered_recommendations(req.user_profile, req.loan_options)
#     return RecommendationResponse(recommendations=recommendations, message=message)

# from typing import List
# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel, Field
# import joblib
# import numpy as np
# import pandas as pd
# from sklearn.preprocessing import LabelEncoder
# import logging

# # Set up logging
# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# app = FastAPI(title="Loan Recommendation API (Root Endpoint)")

# # ----------------------------
# # 1. Pydantic Models
# # ----------------------------

# class UserProfile(BaseModel):
#     monthly_income: float = Field(..., gt=0, description="Monthly income in currency")
#     annual_income: float = Field(..., gt=0, description="Annual income in currency")
#     total_assets: float = Field(..., gt=0, description="Total assets in currency")
#     total_expenses: float = Field(..., gt=0, description="Total annual expenses in currency")
#     total_taken_loans: float = Field(..., gt=0, description="Total amount of loans taken")
#     active_loans: float = Field(..., gt=0, description="Total amount of active loans")
#     avg_interest: float = Field(..., gt=0, lt=1, description="Average interest rate as a decimal")
#     n_loans: int = Field(..., ge=1, description="Number of loans taken")

# class LoanOption(BaseModel):
#     name_of_company: str
#     interest: float = Field(..., gt=0, lt=1, description="Annual interest rate as a decimal (e.g., 0.15)")
#     min_amount: float = Field(..., gt=0, description="Minimum loan amount this product offers")
#     max_amount: float = Field(..., gt=0, description="Maximum loan amount this product offers")
#     payment_term: int = Field(..., ge=1, description="Payment term in months")

# class RecommendedLoan(BaseModel):
#     name_of_company: str
#     interest: float
#     min_amount: float
#     max_amount: float
#     payment_term: int
#     predicted_amount: float
#     predicted_term: int
#     monthly_payment: float

# class RecommendationRequest(BaseModel):
#     user_profile: UserProfile
#     loan_options: List[LoanOption]

# class RecommendationResponse(BaseModel):
#     recommendations: List[RecommendedLoan]
#     message: str = Field(..., description="Status or reason for empty recommendations")

# # ----------------------------
# # 2. Load Pre-trained Models
# # ----------------------------

# try:
#     reg_pipeline = joblib.load("reg_model_improved.pkl")
#     clf_pipeline = joblib.load("clf_model_improved.pkl")
# except FileNotFoundError as e:
#     raise RuntimeError("Model files 'reg_model_improved.pkl' or 'clf_model_improved.pkl' not found.") from e

# # Recreate the LabelEncoder used during training
# term_encoder = LabelEncoder().fit(np.array([12, 24, 36]))

# # ----------------------------
# # 3. Helper Function
# # ----------------------------

# def generate_filtered_recommendations(
#     user: UserProfile,
#     loan_opts: List[LoanOption]
# ) -> tuple[List[RecommendedLoan], str]:
#     """
#     1) Compute engineered features and predict recommended_amount and recommended_term.
#     2) Filter loan options where payment_term == predicted_term and min_amount <= predicted_amount <= max_amount.
#     3) Compute monthly_payment using amortization formula.
#     4) Return all matching options, sorted by monthly_payment (ascending, best first), with a status message.
#     """
#     # (a) Convert user to a single-row DataFrame
#     user_dict = user.dict()
#     X_user = pd.DataFrame([user_dict])

#     # (b) Add engineered features (same as in training)
#     X_user["debt_to_income"] = X_user["total_taken_loans"] / X_user["annual_income"]
#     X_user["disposable_income"] = X_user["monthly_income"] - X_user["total_expenses"] / 12
#     X_user["loan_to_asset"] = X_user["active_loans"] / X_user["total_assets"]

#     # (c) Validate input ranges
#     if X_user["debt_to_income"].iloc[0] > 10 or X_user["disposable_income"].iloc[0] < 0:
#         message = "Invalid user profile: debt_to_income too high or negative disposable_income"
#         logger.error(message)
#         return [], message

#     # (d) Predict loan amount
#     pred_amount = float(reg_pipeline.predict(X_user)[0])
#     if pred_amount < 500 or pred_amount > 50000:  # Based on training data range
#         message = f"Predicted amount {pred_amount:.2f} is outside expected range (500–50000)"
#         logger.warning(message)
#         return [], message
#     logger.info(f"Predicted amount: {pred_amount}")

#     # (e) Predict loan term (encoded → decode)
#     pred_term_enc = int(clf_pipeline.predict(X_user)[0])
#     pred_term = int(term_encoder.inverse_transform([pred_term_enc])[0])
#     logger.info(f"Predicted term: {pred_term}")

#     # (f) Build a DataFrame of the provided loan options
#     df_opts = pd.DataFrame([opt.dict() for opt in loan_opts])

#     # (g) Filter to options matching predicted_term and amount range
#     candidates = df_opts[
#         (df_opts["payment_term"] == pred_term) &
#         (df_opts["min_amount"] <= pred_amount) &
#         (df_opts["max_amount"] >= pred_amount)
#     ].copy()

#     # (h) Check if any candidates match
#     if candidates.empty:
#         message = f"No loan options match predicted term ({pred_term} months) and amount ({pred_amount:.2f})"
#         logger.info(message)
#         return [], message

#     # (i) Compute monthly payment using amortization formula
#     candidates["predicted_amount"] = round(pred_amount, 0)
#     candidates["predicted_term"] = pred_term
#     candidates["monthly_payment"] = candidates.apply(
#         lambda row: round(
#             pred_amount * (row["interest"] / 12) / (1 - (1 + row["interest"] / 12) ** -pred_term), 0
#         ),
#         axis=1
#     )

#     # (j) Sort by monthly_payment (ascending) to put best option first
#     candidates = candidates.sort_values(by="monthly_payment", ascending=True).reset_index(drop=True)

#     # (k) Convert to RecommendedLoan models
#     recs: List[RecommendedLoan] = []
#     for _, row in candidates.iterrows():
#         rec = RecommendedLoan(
#             name_of_company=row["name_of_company"],
#             interest=row["interest"],
#             min_amount=row["min_amount"],
#             max_amount=row["max_amount"],
#             payment_term=int(row["payment_term"]),
#             predicted_amount=float(row["predicted_amount"]),
#             predicted_term=int(row["predicted_term"]),
#             monthly_payment=float(row["monthly_payment"])
#         )
#         recs.append(rec)

#     message = f"Found {len(recs)} matching loan options, sorted by monthly payment (best first)"
#     logger.info(message)
#     return recs, message

# # ----------------------------
# # 4. API Endpoint
# # ----------------------------

# @app.post("/recommend_loan_all", response_model=RecommendationResponse)
# async def recommend_loan_all(req: RecommendationRequest):
#     # Validate loan options
#     if not req.loan_options:
#         raise HTTPException(status_code=400, detail="loan_options list cannot be empty")

#     recommendations, message = generate_filtered_recommendations(req.user_profile, req.loan_options)
#     return RecommendationResponse(recommendations=recommendations, message=message)

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
        clf_pipeline = joblib.load("clf_model_improved.pkl")
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
