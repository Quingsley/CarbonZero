import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

/// a time line tile widget
class KTimelineTile extends StatelessWidget {
  /// a time line tile widget
  const KTimelineTile({
    required this.isLast,
    required this.isFirst,
    required this.isPast,
    this.child,
    super.key,
  });

  /// last tile
  final bool isLast;

  /// first tile
  final bool isFirst;

  /// child widget for the tile
  final Widget? child;

  /// if the tile is past
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        isFirst: isFirst,
        isLast: isLast,
        endChild: Container(
          margin: const EdgeInsets.only(top: 10),
          child: child,
        ),
        lineXY: .5,
        beforeLineStyle: LineStyle(
          color: !isPast
              ? context.colors.primaryContainer
              : context.colors.primary,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: !isPast
              ? context.colors.primaryContainer
              : context.colors.primary,
          iconStyle: IconStyle(
            iconData: isPast ? Icons.done : Icons.close,
            color: !isPast ? context.colors.primary : context.colors.secondary,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
