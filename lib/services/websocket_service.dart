import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/main.dart'; // Import main to access notificationService
import 'package:web_socket_channel/web_socket_channel.dart';

/// Data class for the JSON payload from the Python server.
class DriverAlert {
  final String alert;
  final String intervention;

  DriverAlert({required this.alert, required this.intervention});

  factory DriverAlert.fromJson(Map<String, dynamic> json) {
    return DriverAlert(
      alert: json['alert'] ?? 'UNKNOWN',
      intervention: json['intervention'] ?? '',
    );
  }
}

/// Manages the WebSocket connection to the Python AI core.
class WebSocketService {
  WebSocketChannel? _channel;
  
  // A broadcast controller allows multiple widgets to listen to the stream.
  // This fixes the "Stream has already been listened to" error.
  final StreamController<DriverAlert> _alertController =
      StreamController<DriverAlert>.broadcast();

  /// Public stream that widgets can listen to for new alerts.
  Stream<DriverAlert> get alertStream => _alertController.stream;

  /// Establishes connection with the WebSocket server.
  void connect() {
    try {
      // IMPORTANT:
      // - If using Android Emulator: 'ws://10.0.2.2:8765'
      // - If using iOS Simulator: 'ws://localhost:8765' or 'ws://127.0.0.1:8765'
      // - If using a REAL device: 'ws://<Your-Computer-IP>:8765'
      const wsUrl = 'ws://10.0.2.2:8765'; // Default for Android Emulator

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Internal listener for all data from the WebSocket.
      _channel!.stream.listen(
        (data) {
          if (kDebugMode) {
            print('Data received: $data');
          }
          try {
            // Parse the incoming JSON data
            final driverAlert =
                DriverAlert.fromJson(jsonDecode(data as String));
            
            // 1. Add to the stream controller to update the in-app UI
            _alertController.add(driverAlert);

            // 2. Trigger a system notification if the alert is critical
            if (driverAlert.alert != "SAFE") {
              notificationService.showNotification(
                "Driver Alert: ${driverAlert.alert}", // Notification Title
                driverAlert.intervention,             // Notification Body
              );
            }
            
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing WebSocket JSON: $e');
            }
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('WebSocket Error: $error');
          }
          _reconnect();
        },
        onDone: () {
          if (kDebugMode) {
            print('WebSocket disconnected');
          }
          _reconnect();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting WebSocket: $e');
      }
    }
  }

  /// Attempts to reconnect to the WebSocket server after a delay.
  void _reconnect() {
    // Simple 5-second delay reconnect logic
    Future.delayed(const Duration(seconds: 5), () {
      if (kDebugMode) {
        print('Reconnecting to WebSocket...');
      }
      connect();
    });
  }

  /// Closes the WebSocket connection and stream controller.
  void dispose() {
    _channel?.sink.close();
    _alertController.close();
  }
}