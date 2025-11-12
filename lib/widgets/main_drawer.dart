import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a SafeArea to avoid the system's top status bar
    return Drawer(
      backgroundColor: const Color(0xFFFAFAFA), // Light background
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black54, size: 30),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the drawer
                },
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                     // TODO: Replace with your Image.asset('assets/profile_pic.png')
                    child: const Icon(Icons.person, size: 30, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sahil Patel',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'sahil74052@gmail.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // --- List of items ---
            _buildDrawerItem(
              context,
              icon: Icons.person_outline,
              text: 'Profile',
              onTap: () {
                // TODO: Navigate to Profile
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              text: 'About',
              onTap: () {
                // TODO: Navigate to About
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.notifications_none,
              text: 'Notifications',
              onTap: () {
                // TODO: Navigate to Notifications
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings_outlined,
              text: 'Settings',
              onTap: () {
                // TODO: Navigate to Settings
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.help_outline,
              text: 'Help and Support',
              onTap: () {
                // TODO: Navigate to Help
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                // TODO: Handle Logout
              },
            ),

            // Pushes version info to the bottom
            const Spacer(),

            // Version Info
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                   Text(
                    'Version : 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                   Text(
                    'Last updated on 17 june 2021 at 11:30 pm',
                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                       color: Colors.black45,
                     ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each list tile
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}