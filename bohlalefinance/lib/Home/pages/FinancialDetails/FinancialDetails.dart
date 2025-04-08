import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bohlalefinance/Home/pages/FinancialDetails/screens/Deposits.dart';
import 'package:bohlalefinance/Home/pages/FinancialDetails/screens/Dept.dart';
import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';

class Financialdetails extends StatefulWidget {
  const Financialdetails({super.key});

  @override
  State<Financialdetails> createState() => _FinancialdetailsState();
}

class _FinancialdetailsState extends State<Financialdetails> {
  int selectedValue = 0;

  final List<Widget> _pages = [DeptForm(), DepositsForm()];
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
                          ElevatedButton(
                            onPressed: () {
                              setDialogState(() {
                                selectedValue = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              "Deposits",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.accentColor,
                          ),
                          title: Text(
                            "Lesaoana Financial Services",
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
                            // Handle tap event
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height * 0.02,
                ),
                Text(
                  "Deposits",
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.accentColor,
                          ),
                          title: Text(
                            "Fixing laptop",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("Ecocash: M300"),
                          trailing: Icon(
                            Icons.savings,
                            color: AppColors.accentColor,
                          ),
                          onTap: () {
                            // Handle tap event
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
