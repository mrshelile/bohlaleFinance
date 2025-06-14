import 'package:bohlalefinance/Home/pages/Main/screens/AddExpenses.dart';
import 'package:bohlalefinance/Home/pages/Main/screens/addAssets.dart';
import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bohlalefinance/models/Assets.dart';
import '../../../models/expenses.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedValue = 0;

  late Future<double> _totalAssetsFuture;
  late Future<double> _totalExpensesFuture;
  late Future<List<Asset>> _assetsFuture;
  late Future<List<Expense>> _expensesFuture;

  final List<Widget> _pages = [AddAssets(), AddExpenses()];

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    setState(() {
      _totalAssetsFuture = Asset.getTotalAmount();
      _totalExpensesFuture = Expense.getTotalAmount();
      _assetsFuture = Asset.getAll();
      _expensesFuture = Expense.getAll();
    });
  }

  Future<void> _onRefresh() async {
    _reloadData();
    // Optionally, wait for data to reload
    await Future.wait([
      _totalAssetsFuture,
      _totalExpensesFuture,
      _assetsFuture,
      _expensesFuture,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            "Assets",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            "Expenses",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _pages[selectedValue],
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
          )..show();
        },
        child: const Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.05),
                Row(
                  children: [
                    _InfoCard(
                      title: "Total Income",
                      future: _totalAssetsFuture,
                      color: AppColors.mainColor,
                      width: width * 0.43,
                    ),
                    const SizedBox(width: 10),
                    _InfoCard(
                      title: "Total Expenses",
                      future: _totalExpensesFuture,
                      color: AppColors.mainColor,
                      width: width * 0.43,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Assets",
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.35,
                  child: FutureBuilder<List<Asset>>(
                    future: _assetsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No assets found"));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final asset = snapshot.data![index];
                          debugPrint("asseting ${asset.toMap()}");
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.accentColor,
                              ),
                              title: Text(
                                asset.assetName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("M${asset.amount}"),
                              trailing: Icon(
                                Icons.cases_outlined,
                                color: AppColors.accentColor,
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Expenses",
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.4,
                  child: FutureBuilder<List<Expense>>(
                    future: _expensesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No expenses found"));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final expense = snapshot.data![index];
                          debugPrint("expense ${expense.toMap()}");
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.accentColor,
                              ),
                              title: Text(
                                expense.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("M${expense.amount}"),
                              trailing: Icon(
                                Icons.holiday_village,
                                color: AppColors.accentColor,
                              ),
                              onTap: () {},
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
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Future<double> future;
  final Color color;
  final double width;

  const _InfoCard({
    required this.title,
    required this.future,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          FutureBuilder<double>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                );
              }
              final value = snapshot.data ?? 0.0;
              return Text(
                "R $value",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              );
            },
          ),
        ],
      ),
    );
  }
}
