import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart'; // To access global webSocketService
import 'package:flutter_app/models/mock_trip_data.dart';
import 'package:flutter_app/screens/trip_detail_screen.dart'; // Import the new screen
import 'package:flutter_app/services/websocket_service.dart';
import 'package:flutter_app/widgets/trip_card.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  String _currentStatus = "SAFE";
  String _currentIntervention = "All clear. Drive safe!";

  @override
  void initState() {
    super.initState();
    // Listen to the alert stream
    webSocketService.alertStream.listen((alert) {
      if (mounted) {
        // Update the UI
        setState(() {
          _currentStatus = alert.alert;
          _currentIntervention = alert.intervention;
        });

        // Show a popup dialog for critical alerts
        if (alert.alert != "SAFE") {
          _showAlertDialog(alert);
        }
      }
    });
  }

  // Helper method to show the alert as a popup
  void _showAlertDialog(DriverAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(
          "DRIVER ALERT: ${alert.alert}",
          style: TextStyle(color: _getStatusColor(alert.alert)),
        ),
        content: Text(alert.intervention,
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Helper method to get the right color for the status
  Color _getStatusColor(String status) {
    switch (status) {
      case "IMPAIRED":
      case "AGITATED":
        return Colors.red[800]!;
      case "DROWSY":
      case "STRESSED":
        return Colors.orange[800]!;
      case "SAFE":
      default:
        return Colors.green[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- MODIFIED ---
    // NO Scaffold, NO AppBar. Just the SingleChildScrollView
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- This is the LIVE STATUS widget ---
          Card(
            color: _getStatusColor(_currentStatus),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LIVE STATUS: $_currentStatus",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentIntervention,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- This is the STATIC MOCK DATA ---
          Text(
            "DASHBOARD", // From screenshot
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),

          // --- USE ListView.builder to build cards from mock data ---
          ListView.builder(
            itemCount: mockTrips.length,
            shrinkWrap: true, // Needed inside a SingleChildScrollView
            physics:
                const NeverScrollableScrollPhysics(), // Disables inner scrolling
            itemBuilder: (context, index) {
              final trip = mockTrips[index];

              // --- MODIFICATION ---
              // Wrap the card in a GestureDetector to make it tappable
              return GestureDetector(
                onTap: () {
                  // Navigate to the detail screen, passing the specific trip
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailScreen(trip: trip),
                    ),
                  );
                },
                child: TripCard(
                  startLocation: trip.startLocation,
                  endLocation: trip.endLocation,
                  distance: trip.distance,
                  time: trip.time,
                  speed: trip.speed,
                  totalAlerts: trip.totalAlerts,
                  performance: trip.performance,
                  performanceColor: trip.performanceColor,
                  performancePercent: trip.performancePercent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}