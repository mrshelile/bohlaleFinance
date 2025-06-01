import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bohlalefinance/Home/pages/FinancialDetails/screens/Dept.dart';
import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';

import '../../../models/dept.dart';

class Financialdetails extends StatefulWidget {
  const Financialdetails({super.key});

  @override
  State<Financialdetails> createState() => _FinancialdetailsState();
}

class _FinancialdetailsState extends State<Financialdetails> {
  int selectedValue = 0;
  late Future<List<Dept>> _deptsFuture;
  late Future<List<Map<String, dynamic>>> _unpaidLoansFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _deptsFuture = Dept.getAll();
    _unpaidLoansFuture = Dept.getAllTakenLoans();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLoanDialog,
        child: const Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  "Loans",
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: FutureBuilder<List<Dept>>(
                    future: _deptsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final depts = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: depts.length,
                        itemBuilder: (context, index) {
                          final dept = depts[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.accentColor,
                              ),
                              title: Text(
                                dept.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("M${dept.maxAmount}"),
                              trailing: Icon(
                                Icons.business_center,
                                color: AppColors.accentColor,
                              ),
                              onTap: () => _showTakeLoanDialog(dept),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Unpaid Loans",
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _unpaidLoansFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final unpaidLoans = snapshot.data ?? [];
                      if (unpaidLoans.isEmpty) {
                        return const Center(child: Text('No unpaid loans found.'));
                      }
                      return ListView.builder(
                        itemCount: unpaidLoans.length,
                        itemBuilder: (context, index) {
                          final unpaidLoan = unpaidLoans[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(
                                unpaidLoan['paid']
                                    ? Icons.check_circle
                                    : Icons.warning_amber_rounded,
                                color: unpaidLoan['paid'] ? Colors.green : Colors.redAccent,
                              ),
                              title: Text(
                                unpaidLoan['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("M${(unpaidLoan['amount'] as double).toStringAsFixed(2)}"),
                              onTap: () => _handleUnpaidLoanTap(unpaidLoan),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddLoanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.info,
          body: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setDialogState(() {
                            selectedValue = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                        child: const Text(
                          "Loans",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DeptForm(),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
          title: 'This is Ignored',
          desc: 'This is also Ignored',
        ).show();
        return const SizedBox.shrink();
      },
    );
  }

  void _showTakeLoanDialog(Dept dept) {
    double recommendedAmount = dept.maxAmount * 0.8;
    double amount = recommendedAmount;
    int recommendedTerm = dept.paymentTerm;
    int term = recommendedTerm;

    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Take a Loan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.accentColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Loan Name: ${dept.name}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text("Recommended Amount: M${recommendedAmount.toStringAsFixed(2)}"),
              Slider(
                value: amount,
                min: dept.minAmount,
                max: dept.maxAmount,
                divisions: ((dept.maxAmount - dept.minAmount) / 100).round(),
                label: "M${amount.toStringAsFixed(2)}",
                onChanged: (value) {
                  setDialogState(() {
                    amount = value;
                  });
                },
              ),
              Text("Amount to take: M${amount.toStringAsFixed(2)}"),
              const SizedBox(height: 10),
              Text("Recommended Term: $recommendedTerm months"),
              Slider(
                value: term.toDouble(),
                min: 1,
                max: dept.paymentTerm.toDouble(),
                divisions: dept.paymentTerm,
                label: "$term months",
                onChanged: (value) {
                  setDialogState(() {
                    term = value.round();
                  });
                },
              ),
              Text("Term: $term months"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await Dept.takeLoan(
                          loanId: dept.id,
                          amount: amount,
                          paymentTerm: term,
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Loan taken successfully!")),
                        );
                        _refresh();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error taking loan: $error")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
    )..show();
  }

  void _handleUnpaidLoanTap(Map<String, dynamic> unpaidLoan) async {
    if (unpaidLoan['paid']) return;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Mark as Paid"),
          content: Text("Are you sure you want to mark '${unpaidLoan['name']}' as paid?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await Dept.updatePaidStatus(
                  takenLoanId: unpaidLoan['id'],
                  paid: true,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Loan marked as paid successfully!")),
                );
                _refresh();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
