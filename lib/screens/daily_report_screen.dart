import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/alert_stats_graph.dart';

class DailyReportScreen extends StatelessWidget {
  const DailyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- MODIFIED ---
    // NO Scaffold, NO AppBar. Just the SingleChildScrollView
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Date Selector ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.chevron_left),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '17 June 2021',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Alert Count ---
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 32),
              children: [
                TextSpan(
                  text: '12',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' Alerts',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- The Graph ---
          const AlertStatsGraph(),

          const SizedBox(height: 32),

          // --- Legend ---
          _buildLegend(),

          const SizedBox(height: 32),

          // --- Summary Stats ---
          _buildSummaryStats(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _legendItem(AlertStatsGraph.alcohol, "Alcohol Alerts - 1"),
            _legendItem(AlertStatsGraph.harshBrake, "Harsh brake Alerts - 3"),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _legendItem(AlertStatsGraph.drowsiness, "Drowsiness Alerts - 5"),
            _legendItem(AlertStatsGraph.roadRage, "Road Rage Alerts - 3"),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSummaryStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statRow("Total Trips", "1"),
        _statRow("Total Distance Driven", "110 km"),
        _statRow("Highest Speed of all day", "140 km/h", isHighlight: true),
      ],
    );
  }

  Widget _statRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.red[400] : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}