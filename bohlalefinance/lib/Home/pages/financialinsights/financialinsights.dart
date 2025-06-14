import 'package:bohlalefinance/services/smartAI.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../models/dept.dart';

class FinancialInsightsChart extends StatelessWidget {
  const FinancialInsightsChart({Key? key}) : super(key: key);

  /// Groups loan amounts by month in the format 'yyyy-MM'.
  Map<String, double> _groupLoansByMonth(List<Map<String, dynamic>> loans) {
    final Map<String, double> monthlyTotals = {};
    for (var loan in loans) {
      final date = DateTime.tryParse(loan['date'] ?? '') ?? DateTime.now();
      final monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      monthlyTotals[monthKey] =
          (monthlyTotals[monthKey] ?? 0) + (loan['amount'] as num).toDouble();
    }
    return monthlyTotals;
  }

  /// Generates a list of month keys from the earliest loan to 10 days ahead of now.
  List<String> _generateMonthKeys(
      Map<String, double> monthlyTotals, DateTime now) {
    if (monthlyTotals.isEmpty) {
      // If no data, show last 6 months + 10 days ahead
      final start = DateTime(now.year, now.month - 5);
      final end = DateTime(now.year, now.month, now.day + 10);
      return _monthRange(start, end);
    }
    final sortedKeys = monthlyTotals.keys.toList()..sort();
    final first = sortedKeys.first;
    final firstParts = first.split('-');
    final start = DateTime(int.parse(firstParts[0]), int.parse(firstParts[1]));
    final end = DateTime(now.year, now.month, now.day + 10);
    return _monthRange(start, end);
  }

  /// Returns a list of month keys between start and end (inclusive).
  List<String> _monthRange(DateTime start, DateTime end) {
    final months = <String>[];
    var current = DateTime(start.year, start.month);
    final last = DateTime(end.year, end.month);
    while (!current.isAfter(last)) {
      months.add("${current.year}-${current.month.toString().padLeft(2, '0')}");
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  /// Converts month keys to display labels like "Jan '24".
  List<String> _monthLabels(List<String> monthKeys) {
    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthKeys.map((k) {
      final parts = k.split('-');
      final monthNum = int.parse(parts[1]);
      return "${monthNames[monthNum]} '${parts[0].substring(2)}";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
      onPressed: () async{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("AI Processing wait a few"),
              backgroundColor: Colors.amber,
            ),
          );
       final ai = await SmartAIcallService.create();
       final res = await ai.getLoanRecommendation();
       debugPrint(res.toMap().toString());
        if (res.toMap().containsKey('recommendations')) {
          final List recs = res.toMap()['recommendations'];
          if (recs.isEmpty && res.toMap().containsKey('message')) {
            // Show a cool popup for bad debt-to-income ratio
            showDialog(
              context: context,
              builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 56),
                const SizedBox(height: 18),
                Text(
            "Loan Not Recommended",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
            "Your debt-to-income ratio is too high or your disposable income is negative. You currently do not qualify for any new loans.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.close, color: Colors.white),
            label: const Text(
              "Close",
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
              ),
            );
          } else {
            final top4 = recs.take(4).toList();
            showDialog(
              context: context,
              builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            Icon(Icons.recommend, color: Colors.indigo, size: 48),
            const SizedBox(height: 12),
            Text(
              "Top Loan Recommendations",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ...top4.map((rec) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
              color: Colors.indigo.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo[100],
                  child: Icon(Icons.account_balance, color: Colors.indigo[700]),
                ),
                title: Text(
                  rec['name_of_company'] ?? '',
                  style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.indigo[900],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Text(
                "Interest: ${(rec['interest'] * 100).toStringAsFixed(2)}%",
                style: TextStyle(color: Colors.indigo[700], fontSize: 13),
              ),
              Text(
                "Term: ${rec['payment_term']} months",
                style: TextStyle(color: Colors.indigo[700], fontSize: 13),
              ),
              Text(
                "Monthly: R${rec['monthly_payment'].toStringAsFixed(2)}",
                style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.w600, fontSize: 14),
              ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              Text(
                "Min: R${rec['min_amount'].toStringAsFixed(0)}",
                style: TextStyle(fontSize: 12, color: Colors.indigo[700]),
              ),
              Text(
                "Max: R${rec['max_amount'].toStringAsFixed(0)}",
                style: TextStyle(fontSize: 12, color: Colors.indigo[700]),
              ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Close",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
                ],
              ),
            ),
          ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No recommendations found."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        
      },
      backgroundColor: Colors.indigo,
      child: const Icon(Icons.analytics, color: Colors.white),
      tooltip: 'Analyse',
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
      future: Dept.getAllTakenLoans(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
        }
        final loans = snapshot.data ?? [];
        final monthlyTotals = _groupLoansByMonth(loans);
        final monthKeys = _generateMonthKeys(monthlyTotals, now);
        final monthLabels = _monthLabels(monthKeys);

        // Fill values for all months, even if 0
        final values = monthKeys
          .map((k) => monthlyTotals.containsKey(k) ? monthlyTotals[k]! : 0.0)
          .toList();

        // If all values are zero, set min/max for chart
        final minY = values.any((v) => v != 0)
          ? (values.reduce((a, b) => a < b ? a : b) * 0.95)
          : 0.0;
        final maxY = values.any((v) => v != 0)
          ? (values.reduce((a, b) => a > b ? a : b) * 1.05)
          : 1000.0;

        final spots = List.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i]),
        );

        return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Text(
            "Debt Growth",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
              letterSpacing: 1.2,
              shadows: [
              Shadow(
                color: Colors.indigo.withOpacity(0.10),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
              ],
            ),
            ),
            const SizedBox(height: 16),
            Center(
            child: Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo[50]!, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                color: Colors.indigo.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
                ),
              ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(18),
              height: 340,
              width: double.infinity,
              child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval:
                  ((maxY - minY) / 5).clamp(100, 1000),
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.indigo[100],
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.indigo[100],
                  strokeWidth: 1,
                ),
                ),
                titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 48,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.indigo[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    ),
                  ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    int idx = value.toInt();
                    if (idx >= 0 && idx < monthLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                      monthLabels[idx],
                      style: TextStyle(
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      ),
                    );
                    }
                    return const SizedBox.shrink();
                  },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.indigo[100]!, width: 1.5),
                ),
                lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigoAccent],
                  ),
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeColor: Colors.indigo,
                    strokeWidth: 3,
                  ),
                  ),
                  belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                    Colors.indigo.withOpacity(0.18),
                    Colors.indigo.withOpacity(0.01)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  ),
                ),
                ],
                lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                    "${monthLabels[spot.x.toInt()]}\nR${spot.y.toStringAsFixed(2)}",
                    TextStyle(
                      color: Colors.indigo[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    );
                  }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                ),
              ),
              duration: const Duration(milliseconds: 900),
              ),
            ),
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(Colors.indigo),
              const SizedBox(width: 8),
              Text(
              "Actual Debt",
              style: TextStyle(
                fontSize: 15,
                color: Colors.indigo[900],
                fontWeight: FontWeight.w600,
              ),
              ),
            ],
            ),
            const SizedBox(height: 30),
          ],
          ),
        ),
        );
      },
      ),
    );
  }

  Widget _legendDot(Color color, {bool dashed = false}) {
    return Container(
      width: 22,
      height: 8,
      decoration: BoxDecoration(
        color: dashed ? Colors.transparent : color,
        border: dashed ? Border.all(color: color, width: 2) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: dashed
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Container(
                  width: 4,
                  height: 8,
                  color: color,
                ),
              ),
            )
          : null,
    );
  }
}
