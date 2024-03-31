import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Default skeleton widget.
class DefaultSkeleton extends StatelessWidget {
  /// Default skeleton constructor.
  const DefaultSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person_outline),
              ),
              title: Text(BoneMock.name),
              subtitle: Text(BoneMock.subtitle),
            ),
          );
        },
      ),
    );
  }
}
