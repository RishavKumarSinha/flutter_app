import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String startLocation;
  final String endLocation;
  final String distance;
  final String time;
  final String speed;
  final String totalAlerts;
  final String performance;
  final Color performanceColor;
  final String performancePercent;

  const TripCard({
    super.key, // Use super.key for constructors
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.time,
    required this.speed,
    required this.totalAlerts,
    required this.performance,
    required this.performanceColor,
    required this.performancePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2a2a2a), // Dark card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row 1: Location and Percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(startLocation, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(endLocation,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                // This would be a circular percent indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: performanceColor, width: 3),
                  ),
                  child: Text(
                    performancePercent,
                    style: TextStyle(
                      color: performanceColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row 2: Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black, // Black background for stats
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(distance, "Km", "Total Distance"),
                  _buildStatColumn(time, "", "Time"),
                  _buildStatColumn(speed, "km/h", "Highest Speed"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Row 3: Alerts
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.red[400], size: 18),
                const SizedBox(width: 8),
                Text("Total Alerts: $totalAlerts",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.show_chart, color: performanceColor, size: 18),
                const SizedBox(width: 8),
                Text(performance, style: TextStyle(color: performanceColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the stats
  Widget _buildStatColumn(String value, String unit, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // <-- This ensures text is visible
            ),
            children: [
              TextSpan(text: value),
              TextSpan(
                text: " $unit",
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }
}