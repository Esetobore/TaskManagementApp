import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskStatisticsChart extends StatelessWidget {
  final Map<String, int> statistics;

  const TaskStatisticsChart({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (statistics.values.isEmpty ? 0 : statistics.values.reduce((a, b) => a > b ? a : b)) * 1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String status = getStatusName(groupIndex);
                    return BarTooltipItem(
                      '$status\n${rod.toY.toInt()}',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          getStatusName(value.toInt()),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    reservedSize: 60,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade300),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 1,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: [
                createBarGroup(0, statistics['in_progress'] ?? 0, Colors.blue),
                createBarGroup(1, statistics['completed'] ?? 0, Colors.green),
                createBarGroup(2, statistics['on_hold'] ?? 0, Colors.orange),
                createBarGroup(3, statistics['pending'] ?? 0, Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData createBarGroup(int x, int y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  String getStatusName(int index) {
    switch (index) {
      case 0:
        return 'In Progress';
      case 1:
        return 'Completed';
      case 2:
        return 'On Hold';
      case 3:
        return 'Pending';
      default:
        return '';
    }
  }
}
