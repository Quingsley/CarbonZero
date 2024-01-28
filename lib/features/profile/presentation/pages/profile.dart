import 'package:flutter/material.dart';

/// user profile page
class Profile extends StatelessWidget {
  /// constructor call
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('PROFILE'),
      ),
    );
  }
}
