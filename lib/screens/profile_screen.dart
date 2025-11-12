import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[800],
              // child: Image.asset('assets/profile_pic.png'),
              child: const Icon(Icons.person, size: 50), // Placeholder
            ),
            const SizedBox(height: 16),
            Text(
              'Sahil Patel', // From screenshot
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'sahil74052@gmail.com', // From screenshot
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
  }
}