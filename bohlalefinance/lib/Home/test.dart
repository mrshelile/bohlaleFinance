import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial Summary Section
              SelectableText(
                'Financial Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: SelectableText('Income'),
                  trailing: SelectableText('\$5000'),
                ),
              ),
              Card(
                child: ListTile(
                  title: SelectableText('Expenses'),
                  trailing: SelectableText('\$3000'),
                ),
              ),
              Card(
                child: ListTile(
                  title: SelectableText('Savings'),
                  trailing: SelectableText('\$2000'),
                ),
              ),
              SizedBox(height: 20),

              // Debt & Loan Overview Section
              SelectableText(
                'Debt & Loan Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: SelectableText('Total Debt'),
                  trailing: SelectableText('\$10000'),
                ),
              ),
              Card(
                child: ListTile(
                  title: SelectableText('Monthly Loan Payment'),
                  trailing: SelectableText('\$500'),
                ),
              ),
              SizedBox(height: 20),

              // Interactive Financial Insights Section
              SelectableText(
                'Financial Insights',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 1),
                          FlSpot(1, 3),
                          FlSpot(2, 2),
                          FlSpot(3, 1.5),
                          FlSpot(4, 2.5),
                        ],
                        isCurved: true,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Quick Access Section
              SelectableText(
                'Quick Access',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAccessButton(context, 'Goals', Icons.flag),
                  _buildQuickAccessButton(context, 'Budget', Icons.account_balance_wallet),
                  _buildQuickAccessButton(context, 'Reports', Icons.bar_chart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 5),
        SelectableText(label),
      ],
    );
  }
}