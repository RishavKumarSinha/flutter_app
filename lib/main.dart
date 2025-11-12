import 'package:flutter/material.dart';
import 'package:flutter_app/screens/notification_service.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import 'package:flutter_app/services/websocket_service.dart';
import 'package:google_fonts/google_fonts.dart';

// Create global instances for both services
final WebSocketService webSocketService = WebSocketService();
final NotificationService notificationService = NotificationService(); // New

void main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications BEFORE running the app
  await notificationService.init(); 
  
  // Connect to the WebSocket
  webSocketService.connect();
  
  runApp(const VoloApp());
}

class VoloApp extends StatelessWidget {
  const VoloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const SplashScreen(), // <-- Fix: Added 'const' here
    );
  }
}