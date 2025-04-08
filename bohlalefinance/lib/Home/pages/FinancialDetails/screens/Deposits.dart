import 'package:flutter/material.dart';

class DepositsForm extends StatefulWidget {
  const DepositsForm({super.key});

  @override
  State<DepositsForm> createState() => _DepositsFormState();
}

class _DepositsFormState extends State<DepositsForm> {
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
                labelText: 'Asset Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Monthly salary',
                  child: Text('Monthly salary'),
                ),
                DropdownMenuItem(
                  value: 'Other income',
                  child: Text('Other income'),
                ),
              ],
              onChanged: (value) {},
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
