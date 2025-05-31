import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialInsightsChart extends StatelessWidget {
  // Simulate up and down values
  final List<double> monthlyDebt = [2500, 2700, 2600, 2800, 2700, 2900];
  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  FinancialInsightsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> debtSpots = List.generate(
      monthlyDebt.length,
      (i) => FlSpot(i.toDouble(), monthlyDebt[i]),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).copyWith().size.height*0.2,),
          Text(
            "Debt Growth",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              height: 320,
              width: 400, // Optional: set a fixed width for better centering
              child: LineChart(
                LineChartData(
                  minY: (monthlyDebt.reduce((a, b) => a < b ? a : b) * 0.95),
                  maxY: (monthlyDebt.reduce((a, b) => a > b ? a : b) * 1.05),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 200,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[200],
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey[200],
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx >= 0 && idx < months.length) {
                            return Text(
                              months[idx],
                              style: TextStyle(
                                color: Colors.indigo[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.indigo[100]!, width: 1),
                  ),
                  lineBarsData: [
                    // Actual debt line
                    LineChartBarData(
                      spots: debtSpots,
                      isCurved: true,
                      color: Colors.indigo,
                      barWidth: 4,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.indigo.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(Colors.indigo),
              SizedBox(width: 6),
              Text("Actual Debt", style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, {bool dashed = false}) {
    return Container(
      width: 18,
      height: 6,
      decoration: BoxDecoration(
        color: dashed ? Colors.transparent : color,
        border: dashed ? Border.all(color: color, width: 2) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: dashed
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Container(
                  width: 3,
                  height: 6,
                  color: color,
                ),
              ),
            )
          : null,
    );
  }
}
