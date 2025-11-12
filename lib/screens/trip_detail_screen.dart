import 'package:flutter/material.dart';
import 'package:flutter_app/models/mock_trip_data.dart';
import 'package:flutter_app/widgets/speed_graph.dart';

class TripDetailScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The back button is added automatically
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Text(
              '${trip.startLocation} to ${trip.endLocation}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '12 Nov 2025, 05:40 pm', // Hardcoded from screenshot
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
            
            // --- Map Placeholder ---
            Container(
              height: 250,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                // Placeholder for the map route image

                child: Image(
                  image: AssetImage('assets/images/map.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // --- Stats (like TripCard) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black, // Black background for stats
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(trip.distance, "Km", "Total Distance"),
                  _buildStatColumn(trip.time, "", "Time"),
                  _buildStatColumn(trip.speed, "km/h", "Highest Speed"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // --- Alert Details ---
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  const WidgetSpan(
                      child: Icon(Icons.warning_amber_rounded,
                          color: Colors.redAccent, size: 20),
                      alignment: PlaceholderAlignment.middle),
                  TextSpan(text: ' Total Alerts : ${trip.totalAlerts}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // --- Alert Legend (Hardcoded) ---
            _buildLegendItem(Colors.cyan, "Seat Belt Alerts - 1"),
            _buildLegendItem(Colors.blueAccent, "Over Speed Alerts - 5"),
            _buildLegendItem(Colors.purpleAccent, "Harsh brake Alerts - 3"),
            _buildLegendItem(Colors.grey[400]!, "Car-idling Alerts - 3"),
            
            const SizedBox(height: 24),
            
            // --- Remarks ---
            Text(
              "Remarks : ${trip.performance}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // --- Speed Graph ---
            Text(
              "Speed over the time during trip",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            const SpeedGraph(),
            const SizedBox(height: 30), // Padding for bottom
          ],
        ),
      ),
    );
  }

  // Helper for stats
  Widget _buildStatColumn(String value, String unit, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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

  // Helper for legend
  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
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
      ),
    );
  }
}