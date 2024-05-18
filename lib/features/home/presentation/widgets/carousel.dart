import 'package:carbon_zero/features/home/presentation/widgets/home_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
    return CarouselSlider(
      disableGesture: true,
      options: CarouselOptions(
        height: 130,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
      ),
      items: tips.map((
        tip,
      ) {
        return HomeCard(
          title: tip.notification!.title,
          description: tip.notification!.body!,
          icon: Icons.lightbulb,
        );
      }).toList(),
    );
  }
}
