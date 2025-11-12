import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpeedGraph extends StatelessWidget {
  const SpeedGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          // --- Main Styling ---
          backgroundColor: Colors.white.withOpacity(0.1), // Placeholder
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: 70, // 70, 140
            verticalInterval: 500, // Placeholder for time
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[800],
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[800],
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[800]!),
          ),
          
          // --- Axis Titles ---
          titlesData: FlTitlesData(
            // Hide top and right
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            
            // Left (Speed)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 70,
                getTitlesWidget: (value, meta) {
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = '0';
                      break;
                    case 70:
                      text = '70';
                      break;
                    case 140:
                      text = '140';
                      break;
                    default:
                      return Container();
                  }
                  return Text(text,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      textAlign: TextAlign.left);
                },
              ),
            ),
            
            // Bottom (Time)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  // Placeholder time labels
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = '0 m';
                      break;
                    case 500:
                      text = '30 m';
                      break;
                    case 1000:
                      text = '1 h';
                      break;
                    case 1500:
                      text = '1.5 h';
                      break;
                    default:
                      return Container();
                  }
                  return Text(text,
                      style: const TextStyle(color: Colors.grey, fontSize: 10));
                },
              ),
            ),
          ),
          
          // --- Line Data ---
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 40),
                FlSpot(200, 70),
                FlSpot(500, 60),
                FlSpot(700, 90),
                FlSpot(1000, 130),
                FlSpot(1300, 80),
                FlSpot(1500, 100),
              ],
              isCurved: true,
              color: Colors.pinkAccent[100],
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent.withOpacity(0.4),
                    Colors.pinkAccent.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}