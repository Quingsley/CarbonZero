import 'package:flutter/material.dart';

void main() {
  runApp(const CarbonZero());
}

class CarbonZero extends StatelessWidget {
  const CarbonZero({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CarbonZero',
      home: Scaffold(
        body: Center(
          child: Text('CarbonZero'),
        ),
      ),
    );
  }
}
