import 'package:flutter/material.dart';


class FinancialPlanningForm extends StatefulWidget {
  @override
  _FinancialPlanningFormState createState() => _FinancialPlanningFormState();
}

class _FinancialPlanningFormState extends State<FinancialPlanningForm> {
  final _formKey = GlobalKey<FormState>();

  // Income Section Controllers
  final TextEditingController _primaryIncomeController = TextEditingController();
  final TextEditingController _secondaryIncomeController = TextEditingController();
  final TextEditingController _otherIncomeController = TextEditingController();

  // Expenses Section Controllers
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _utilitiesController = TextEditingController();
  final TextEditingController _groceriesController = TextEditingController();
  final TextEditingController _transportationController = TextEditingController();
  final TextEditingController _entertainmentController = TextEditingController();
  final TextEditingController _miscellaneousController = TextEditingController();

  // Debt Section Controllers
  final TextEditingController _debtAmountController = TextEditingController();
  final TextEditingController _debtInterestController = TextEditingController();
  final TextEditingController _debtMonthlyPaymentController = TextEditingController();

  // Savings & Goals Section Controllers
  final TextEditingController _currentSavingsController = TextEditingController();
  final TextEditingController _emergencyFundController = TextEditingController();
  final TextEditingController _shortTermGoalController = TextEditingController();
  final TextEditingController _longTermGoalController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers
    _primaryIncomeController.dispose();
    _secondaryIncomeController.dispose();
    _otherIncomeController.dispose();
    _rentController.dispose();
    _utilitiesController.dispose();
    _groceriesController.dispose();
    _transportationController.dispose();
    _entertainmentController.dispose();
    _miscellaneousController.dispose();
    _debtAmountController.dispose();
    _debtInterestController.dispose();
    _debtMonthlyPaymentController.dispose();
    _currentSavingsController.dispose();
    _emergencyFundController.dispose();
    _shortTermGoalController.dispose();
    _longTermGoalController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect Income Data
      double primaryIncome = double.tryParse(_primaryIncomeController.text) ?? 0;
      double secondaryIncome = double.tryParse(_secondaryIncomeController.text) ?? 0;
      double otherIncome = double.tryParse(_otherIncomeController.text) ?? 0;

      // Collect Expense Data
      double rent = double.tryParse(_rentController.text) ?? 0;
      double utilities = double.tryParse(_utilitiesController.text) ?? 0;
      double groceries = double.tryParse(_groceriesController.text) ?? 0;
      double transportation = double.tryParse(_transportationController.text) ?? 0;
      double entertainment = double.tryParse(_entertainmentController.text) ?? 0;
      double miscellaneous = double.tryParse(_miscellaneousController.text) ?? 0;

      // Collect Debt Data
      double debtAmount = double.tryParse(_debtAmountController.text) ?? 0;
      double debtInterest = double.tryParse(_debtInterestController.text) ?? 0;
      double debtMonthlyPayment = double.tryParse(_debtMonthlyPaymentController.text) ?? 0;

      // Collect Savings & Goals Data
      double currentSavings = double.tryParse(_currentSavingsController.text) ?? 0;
      double emergencyFundTarget = double.tryParse(_emergencyFundController.text) ?? 0;
      double shortTermGoal = double.tryParse(_shortTermGoalController.text) ?? 0;
      double longTermGoal = double.tryParse(_longTermGoalController.text) ?? 0;

      // Process data or send to your AI model for planning
      print("Primary Income: $primaryIncome");
      print("Secondary Income: $secondaryIncome");
      print("Other Income: $otherIncome");

      print("Rent: $rent, Utilities: $utilities, Groceries: $groceries, Transportation: $transportation, Entertainment: $entertainment, Misc: $miscellaneous");

      print("Debt Amount: $debtAmount, Interest Rate: $debtInterest, Monthly Payment: $debtMonthlyPayment");

      print("Current Savings: $currentSavings, Emergency Fund Target: $emergencyFundTarget");
      print("Short Term Goal: $shortTermGoal, Long Term Goal: $longTermGoal");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Financial data submitted for planning')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Planning Input'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Income Section
                Text('Income', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _primaryIncomeController,
                  decoration: InputDecoration(
                    labelText: 'Primary Income (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter primary income' : null,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _secondaryIncomeController,
                  decoration: InputDecoration(
                    labelText: 'Secondary Income (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _otherIncomeController,
                  decoration: InputDecoration(
                    labelText: 'Other Income (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Expenses Section
                Text('Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _rentController,
                  decoration: InputDecoration(
                    labelText: 'Rent/Mortgage (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter rent or mortgage' : null,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _utilitiesController,
                  decoration: InputDecoration(
                    labelText: 'Utilities (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _groceriesController,
                  decoration: InputDecoration(
                    labelText: 'Groceries (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _transportationController,
                  decoration: InputDecoration(
                    labelText: 'Transportation (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _entertainmentController,
                  decoration: InputDecoration(
                    labelText: 'Entertainment (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _miscellaneousController,
                  decoration: InputDecoration(
                    labelText: 'Miscellaneous (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Debt Section
                Text('Debt Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _debtAmountController,
                  decoration: InputDecoration(
                    labelText: 'Total Debt Amount (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _debtInterestController,
                  decoration: InputDecoration(
                    labelText: 'Interest Rate (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _debtMonthlyPaymentController,
                  decoration: InputDecoration(
                    labelText: 'Monthly Debt Payment (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Savings & Goals Section
                Text('Savings & Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _currentSavingsController,
                  decoration: InputDecoration(
                    labelText: 'Current Savings (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emergencyFundController,
                  decoration: InputDecoration(
                    labelText: 'Emergency Fund Target (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _shortTermGoalController,
                  decoration: InputDecoration(
                    labelText: 'Short Term Goal (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _longTermGoalController,
                  decoration: InputDecoration(
                    labelText: 'Long Term Goal (M)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit Financial Data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
