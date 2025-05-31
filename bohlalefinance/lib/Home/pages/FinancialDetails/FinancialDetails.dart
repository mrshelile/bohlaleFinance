import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bohlalefinance/Home/pages/FinancialDetails/screens/Deposits.dart';
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

  final List<Widget> _pages = [DeptForm()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.info,
              body: StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState) {
                  return Column(
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              "Loans",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          
                        ],
                      ),
                      SizedBox(height: 10),
                      _pages[selectedValue],
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
              title: 'This is Ignored',
              desc: 'This is also Ignored',
            )..show();
          },
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.mainColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height * 0.05,
                ),
                Text(
                  "Loans",
                  style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: MediaQuery.of(context).copyWith().size.height*0.02,),
                Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.35,
                  // margin: EdgeInsets.all(20),
                  child: FutureBuilder(
                  future: Dept.getAll(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final depts = snapshot.data as List<Dept>;
                    return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: depts.length,
                    itemBuilder: (context, index) {
                      final dept = depts[index];
                      return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.accentColor,
                        ),
                        title: Text(
                        dept.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        subtitle: Text("M300"),
                        trailing: Icon(
                        Icons.business_center,
                        color: AppColors.accentColor,
                        ),
                        onTap: () {
                        double recommendedAmount = 1000.0;
                        double amount = recommendedAmount;
                        int recommendedTerm = 12;
                        int term = recommendedTerm;

                        final parentContext = context;

                        AwesomeDialog(
                          context: parentContext,
                          animType: AnimType.scale,
                          dialogType: DialogType.info,
                          body: StatefulBuilder(
                          builder: (BuildContext dialogContext, StateSetter setDialogState) {
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
                              SizedBox(height: 10),
                              Text(
                              "Loan Name: ${dept.name}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              ),
                              SizedBox(height: 5),
                              SizedBox(height: 10),
                              Text("Recommended Amount: M$recommendedAmount"),
                              Slider(
                              value: amount,
                              min: 100,
                              max: 5000,
                              divisions: 49,
                              label: "M${amount.round()}",
                              onChanged: (value) {
                                setDialogState(() {
                                amount = value;
                                });
                              },
                              ),
                              Text("Amount to take: M${amount.round()}"),
                              SizedBox(height: 10),
                              Text("Recommended Term: $recommendedTerm months"),
                              Slider(
                              value: term.toDouble(),
                              min: 1,
                              max: 36,
                              divisions: 35,
                              label: "${term.round()} months",
                              onChanged: (value) {
                                setDialogState(() {
                                term = value.round();
                                });
                              },
                              ),
                              Text("Term: $term months"),
                              SizedBox(height: 20),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                onPressed: () {
                                  Navigator.of(parentContext).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                onPressed: () {
                                  // Handle loan submission logic here
                                  Navigator.of(parentContext).pop();
                                  ScaffoldMessenger.of(parentContext).showSnackBar(
                                  SnackBar(content: Text("Loan request for ${dept.name} submitted!")),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                ),
                                child: Text("Submit"),
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
                        },
                      ),
                      );
                    },
                    );
                  }
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Unpaid Loans",
                  style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.25,
                  child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 3, // Example: 3 unpaid loans
                  itemBuilder: (context, index) {
                    // Example generated data
                    final unpaidLoan = {
                    'name': 'Loan ${index + 1}',
                    'amount': 500 + index * 150,
                    };
                    return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      ),
                      title: Text(
                      unpaidLoan['name'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      subtitle: Text("M${unpaidLoan['amount']}"),
                      trailing: Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      ),
                      onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text("Mark as Paid"),
                          content: Text("Are you sure you want to mark '${unpaidLoan['name']}' as paid?"),
                          actions: [
                          TextButton(
                            onPressed: () {
                            Navigator.of(dialogContext).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${unpaidLoan['name']} marked as paid.")),
                            );
                            // Add your logic to mark as paid here
                            },
                            child: Text("Confirm"),
                          ),
                          ],
                        );
                        },
                      );
                      },
                    ),
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
}
