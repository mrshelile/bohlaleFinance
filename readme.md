# BohlaleFinance: Model Training

## Table of Contents

1. [Overview](#overview)
2. [Debt Optimization Model](#debt-optimization-model)
    - [Features](#features)
    - [Model Explanation](#model-explanation)
3. [Financial Planning Model](#financial-planning-model)
    - [Features](#features-1)
    - [Model Explanation](#model-explanation-1)
4. [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Steps to Run the Jupyter Files](#steps-to-run-the-jupyter-files)

---

## Overview

BohlaleFinance uses machine learning models to assist users with debt optimization and financial planning. The two main models—**Debt Optimization Model** and **Financial Planning Model**—provide users with personalized recommendations for managing their finances. These models evaluate user income and expenses, providing guidance on the best loan options and personalized budgeting plans.

---

## Debt Optimization Model

### Features:
- **Income & Expenses Analysis**: The model analyzes the user’s monthly income and expenses to determine available cash for loan payments.
- **Loan Evaluation**: Evaluates different loan options considering loan amount, interest rate, and repayment terms.
- **Repayment Plan Optimization**: Suggests the best loan repayment plan based on interest rates and payment terms.
- **Loan Recommendation**: Recommends the optimal loan based on the least total interest and best repayment plan.

### Model Explanation:

The Debt Optimization Model helps users optimize loan repayments. It first calculates the available cash based on monthly income and expenses. It then evaluates different loan options by comparing their interest rates, repayment amounts, and durations. The model provides the user with the best loan option by choosing the loan with the lowest total interest paid across a range of repayment periods.

---

## Financial Planning Model

### Features:
- **Income and Expenses Monitoring**: Tracks the user’s income and expenses to generate a financial profile.
- **Personalized Budgeting**: Creates a personalized budget based on user income and expenses, suggesting ideal savings and expenditure levels.
- **Savings Goal Tracking**: Helps users set and track their savings goals over time.
- **Expense Optimization**: Suggests strategies for reducing unnecessary expenses to maximize savings potential.

### Model Explanation:

The Financial Planning Model creates a personalized budget based on the user's income and expenses. It allocates a portion of income for savings (typically 20%) and assigns the remainder for living expenses. The model also provides recommendations for tracking savings goals and optimizing expenses, ensuring that users can meet their financial targets.

---

## Installation

### Prerequisites:
- **Python 3.x**: Make sure you have Python 3.x installed on your machine.
- **Jupyter Notebook**: The models are implemented in Jupyter notebooks. Install it using the following:
    ```bash
    pip install notebook
    ```
- **Numpy**: The models require the `numpy` library for numerical calculations.
    ```bash
    pip install numpy
    ```

### Steps to Run the Jupyter Files:

1. **Clone the Repository**:
   - Start by cloning the BohlaleFinance repository to your local machine.
     ```bash
     git clone https://github.com/your-repo/BohlaleFinance.git
     cd BohlaleFinance
     ```

2. **Install Dependencies**:
   - Install the required dependencies listed above.
     ```bash
     pip install numpy
     pip install notebook
     ```

3. **Open Jupyter Notebook**:
   - Once the dependencies are installed, open the Jupyter Notebook by running the following:
     ```bash
     jupyter notebook
     ```

4. **Run the Debt Optimization Model**:
   - In the Jupyter interface, locate and open the file `debt_optimization_model.ipynb`.
   - Run the cells to see the results of the Debt Optimization Model.

5. **Run the Financial Planning Model**:
   - Similarly, locate and open the file `financial_planning_model.ipynb`.
   - Run the cells to see the results of the Financial Planning Model.

6. **View the Results**:
   - After running the models, the output will provide recommendations for loan optimization or budgeting advice based on the user's financial data.

---

## Conclusion

The **BohlaleFinance** models provide intelligent recommendations for debt management and financial planning. These models aim to empower users by offering personalized financial advice based on their income and expenses, guiding them toward optimal financial decisions. By using these models, users can improve their debt repayment strategies and achieve their financial goals.

---
