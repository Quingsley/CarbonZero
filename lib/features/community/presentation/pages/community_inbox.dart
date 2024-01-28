import 'package:flutter/material.dart';

class CommunityInbox extends StatelessWidget {
  const CommunityInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('INbox'),
      ),
      body: const Center(child: Text('inbox')),
    );
  }
}
