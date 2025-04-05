import 'package:bohlalefinance/Home/pages/Main/screens/AddExpenses.dart';
import 'package:bohlalefinance/Home/pages/Main/screens/addAssets.dart';
import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedValue = 0;

  final List<Widget> _pages = [
    AddAssets(),
    AddExpenses(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                          child: Text(
                            "Assets",
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                          child: Text(
                            "Expenses",
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
              Row(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).copyWith().size.width * 0.43,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Income",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "R 5000",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).copyWith().size.width * 0.43,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Expenses",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "R 5000",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.height * 0.02,
              ),
              Text(
                "Assets",
                style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: MediaQuery.of(context).copyWith().size.height * 0.35,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.account_balance_wallet,
                            color: AppColors.accentColor),
                        title: Text("Investement",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text("M300"),
                        trailing: Icon(Icons.cases_outlined,
                            color: AppColors.accentColor),
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
                "Expenses",
                style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: MediaQuery.of(context).copyWith().size.height * 0.4,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.account_balance_wallet,
                            color: AppColors.accentColor),
                        title: Text("Groceries",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text("M499"),
                        trailing: Icon(Icons.holiday_village,
                            color: AppColors.accentColor),
                        onTap: () {
                          // Handle tap event
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
    );
  }
}

