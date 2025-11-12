import 'package:flutter/material.dart';
import 'package:flutter_app/screens/daily_report_screen.dart';
import 'package:flutter_app/screens/main_dashboard_screen.dart';
import 'package:flutter_app/screens/profile_screen.dart';
import 'package:flutter_app/widgets/main_drawer.dart';

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({super.key});

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MainDashboardScreen(),
    const DailyReportScreen(),
    const ProfileScreen(),
  ];

  // Titles for the AppBar
  final List<String> _titles = [
    'Welcome, Sahil',
    'Daily Report',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        // The hamburger icon will appear and open the drawer
        title: Text(_titles[_currentIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              // TODO: Replace with your Image.asset('assets/profile_pic.png')
              child: const Icon(Icons.person),
            ),
          )
        ],
      ),

      // --- Drawer ---
      drawer: const MainDrawer(),

      // Body is the selected screen
      body: _screens[_currentIndex],

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

        // --- Required Properties ---
        currentIndex: _currentIndex,
        onTap: _onItemTapped,

        // --- Styling (Matches your app theme) ---
        backgroundColor: const Color(0xFF1F1F1F), // Dark background
        selectedItemColor: Colors.white, // Active icon color
        unselectedItemColor: Colors.grey[600], // Inactive icon color
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Ensures all labels are shown
      ),
    );
  }
}