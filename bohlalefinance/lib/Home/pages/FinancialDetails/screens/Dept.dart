import 'package:flutter/material.dart';

class DeptForm extends StatefulWidget {
  const DeptForm({super.key});

  @override
  State<DeptForm> createState() => _DeptFormState();
}

class _DeptFormState extends State<DeptForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Interest',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Min-amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
              const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Max-amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Payment Term(months)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          
           
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
