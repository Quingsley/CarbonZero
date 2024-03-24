import 'package:carbon_zero/features/home/presentation/widgets/home_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

/// Carousel widget for the home screen
/// will display the text of sustainable tips
class HomeCarousel extends StatelessWidget {
  /// Constructor
  const HomeCarousel({required this.itemCount, required this.tips, super.key});

  /// Number of items in the carousel
  final int itemCount;

  /// List of sustainable tips
  final List<RemoteMessage> tips;

  @override
  Widget build(BuildContext context) {
    return InfiniteCarousel.builder(
      itemCount: itemCount,
      itemExtent: 40,
      onIndexChanged: (index) {},
      axisDirection: Axis.vertical,
      itemBuilder: (context, itemIndex, realIndex) {
        return HomeCard(
          title: tips[realIndex].notification!.title,
          description: tips[realIndex].notification!.body!,
          icon: Icons.lightbulb,
        );
      },
    );
  }
}
