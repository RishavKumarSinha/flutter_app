import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AlertStatsGraph extends StatelessWidget {
  const AlertStatsGraph({Key? key}) : super(key: key);

  // Define colors from your screenshot
  static const Color alcohol = Color(0xFFb388ff); // Light purple
  static const Color drowsiness = Color(0xFF00bcd4); // Cyan
  static const Color harshBrake = Color(0xFF607d8b); // Blue grey
  static const Color roadRage = Color(0xFFc6c6c6); // Light grey

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          // --- Styling ---
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            // Horizontal lines
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          
          // --- Axis Titles ---
          titlesData: FlTitlesData(
            // Top titles
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            
            // Right titles
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            
            // Bottom titles (S, M, T...)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitles,
                reservedSize: 30,
              ),
            ),
            
            // Left titles (0, 3, 6, 9, 12)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _leftTitles,
                reservedSize: 28,
                interval: 3, // Show titles every 3 units
              ),
            ),
          ),
          
          // --- Bar Data ---
          barGroups: _getBarGroups(),
          maxY: 12, // Match screenshot
        ),
      ),
    );
  }

  // --- Bar Data (Hardcoded to match screenshot) ---
  List<BarChartGroupData> _getBarGroups() {
    return [
      // S
      _buildGroup(0, [2, 1, 1, 1.5]),
      // M
      _buildGroup(1, [1, 2, 1, 1]),
      // T
      _buildGroup(2, [1, 1, 0.5, 0.5]),
      // W
      _buildGroup(3, [2, 1, 1.5, 2]),
      // T (Active)
      _buildGroup(4, [3, 3, 3, 3], isTouched: true),
      // F
      _buildGroup(5, [2, 1.5, 1, 1]),
      // S
      _buildGroup(6, [2.5, 1, 1.5, 1]),
    ];
  }

  // Helper to build a single bar group
  BarChartGroupData _buildGroup(
    int x,
    List<double> rods, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      // Create the stacked rods
      barRods: [
        BarChartRodData(
          toY: 12, // Max Y
          rodStackItems: [
            BarChartRodStackItem(0, rods[0], roadRage),
            BarChartRodStackItem(rods[0], rods[0] + rods[1], harshBrake),
            BarChartRodStackItem(rods[0] + rods[1], rods[0] + rods[1] + rods[2], drowsiness),
            BarChartRodStackItem(rods[0] + rods[1] + rods[2], rods[0] + rods[1] + rods[2] + rods[3], alcohol),
          ],
          width: 22,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Colors.transparent, // Hides the "empty" part
        ),
      ],
      // Highlight the 'T' bar
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  }

  // --- Axis Title Widgets ---
  Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontSize: 14);
    String text;
    switch (value.toInt()) {
      case 0: text = 'S'; break;
      case 1: text = 'M'; break;
      case 2: text = 'T'; break;
      case 3: text = 'W'; break;
      case 4: text = 'T'; break; // Highlight this
      case 5: text = 'F'; break;
      case 6: text = 'S'; break;
      default: text = ''; break;
    }
    
    // Highlight the 'T'
    final bool isTouched = (value.toInt() == 4);
    
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isTouched ? Colors.grey.shade800 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(
          text,
          style: style.copyWith(
            color: isTouched ? Colors.white : Colors.grey,
            fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontSize: 12);
    String text;
    if (value == 0) {
      return Container(); // Don't show '0'
    } else {
      text = value.toInt().toString();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }
}