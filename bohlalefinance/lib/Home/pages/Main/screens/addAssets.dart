import 'package:flutter/material.dart';

import '../../../../models/Assets.dart';

class AddAssets extends StatefulWidget {
  const AddAssets({super.key});

  @override
  State<AddAssets> createState() => _AddAssetsState();
}

class _AddAssetsState extends State<AddAssets> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _assetNameController,
              decoration: const InputDecoration(
                labelText: 'Asset Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
            onChanged: (value) {
              setState(() {
                _typeController.text = value ?? '';
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Handle form submission
              if (_formKey.currentState!.validate()) {
                final assetName = _assetNameController.text;
                final amountText = _amountController.text;
                final type = _typeController.text;
                final asset = Asset(
                  type: type,
                  assetName: assetName,
                  amount: amountText.isNotEmpty ? double.tryParse(amountText) ?? 0.0 : 0.0,
                );
                await asset.save();
             
                Navigator.of(context).pop();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ));
  }
}
