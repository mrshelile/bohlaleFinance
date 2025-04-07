import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';

class Financialdetails extends StatefulWidget {
  const Financialdetails({super.key});

  @override
  State<Financialdetails> createState() => _FinancialdetailsState();
}

class _FinancialdetailsState extends State<Financialdetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle the button press
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
                  "Dept",
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
