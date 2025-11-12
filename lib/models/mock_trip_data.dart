import 'package:flutter/material.dart';

/// A class to hold all the data for a single trip.
class Trip {
  final String startLocation;
  final String endLocation;
  final String distance;
  final String time;
  final String speed;
  final String totalAlerts;
  final String performance;
  final Color performanceColor;
  final String performancePercent;

  const Trip({
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
}

// --- Mock Data based on your screenshots ---

final List<Trip> mockTrips = [
  const Trip(
    startLocation: "Home",
    endLocation: "Vadodara",
    distance: "110",
    time: "1 h 32 m",
    speed: "140",
    totalAlerts: "12",
    performance: "7.5% poor performance than last trip",
    performanceColor: Colors.redAccent, // Red
    performancePercent: "74%",
  ),
  const Trip(
    startLocation: "Vadodara",
    endLocation: "Home",
    distance: "110",
    time: "1 h 46 m",
    speed: "120",
    totalAlerts: "6",
    performance: "Same performance as last trip",
    performanceColor: Colors.greenAccent, // Green
    performancePercent: "80%",
  ),
  const Trip(
    startLocation: "Vadodara",
    endLocation: "Pune",
    distance: "288",
    time: "5 h 31 m",
    speed: "120",
    totalAlerts: "8",
    performance: "20% poor performance than last trip",
    performanceColor: Colors.greenAccent, // Green
    performancePercent: "80%",
  ),
];