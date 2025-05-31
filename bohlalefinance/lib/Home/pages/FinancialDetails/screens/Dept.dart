import 'package:flutter/material.dart';

import '../../../../models/dept.dart';

class DeptForm extends StatefulWidget {
  const DeptForm({super.key});

  @override
  State<DeptForm> createState() => _DeptFormState();
}

class _DeptFormState extends State<DeptForm> {
  // You can add any necessary controllers or state variables here
  final interestController = TextEditingController();
  final minAmountController = TextEditingController();
  final maxAmountController = TextEditingController();
  final paymentTermController = TextEditingController();
  final deptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: interestController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Interest',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: minAmountController,
              
              decoration: const InputDecoration(
                labelText: 'Min-amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
              const SizedBox(height: 16),
            TextFormField(
              controller: maxAmountController,
              decoration: const InputDecoration(
                labelText: 'Max-amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: paymentTermController,
              decoration: const InputDecoration(
                labelText: 'Payment Term(months)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: deptController,
              decoration: const InputDecoration(
                labelText: 'Dept Name (e.g. Lesana Financials)',
                border: OutlineInputBorder(),
              ),
            ),
           
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                // Handle form submission
                if (interestController.text.isEmpty ||
                    minAmountController.text.isEmpty ||
                    maxAmountController.text.isEmpty ||
                    paymentTermController.text.isEmpty ||
                    deptController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                final deptAmount = double.tryParse(minAmountController.text) ?? 0.0;
                final paymentTerm = int.tryParse(paymentTermController.text) ?? 0;
                final loanId = deptController.text; // Assuming dept name as loanId for now
                final payedAmount = 0.0;

                final dept = Dept(
                  name: deptController.text,
                  interest: double.tryParse(interestController.text) ?? 0.0,
                  deptAmount: deptAmount,
                  paymentTerm: paymentTerm,
                  loanId: loanId,
                  payedAmount: payedAmount,
                );

                await dept.save();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dept saved successfully!')),
                );

                interestController.clear();
                minAmountController.clear();
                maxAmountController.clear();
                paymentTermController.clear();
                deptController.clear();
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
