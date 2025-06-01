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
    return FutureBuilder<List<Map<String, dynamic>>>(
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
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              Text(
                "Debt Growth",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.indigo.withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
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
                        color: Colors.indigo.withOpacity(0.10),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  height: 340,
                  width: 420,
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
        );
      },
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
