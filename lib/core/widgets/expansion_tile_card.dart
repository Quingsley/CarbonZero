import 'package:carbon_zero/core/extensions.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [CustomExpansionTile] is a custom implementation of [ExpansionTileCard]
class CustomExpansionTile extends ConsumerWidget {
  /// Creates a [CustomExpansionTile] widget.
  const CustomExpansionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    super.key,
  });

  /// title
  final String title;

  /// icon
  final IconData icon;

  /// subtitle
  final String subtitle;

  /// date
  final String? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isOpenProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTileCard(
        baseColor: context.colors.inversePrimary,
        initiallyExpanded: true,
        onExpansionChanged: (val) {
          if (val) {
            ref.read(isOpenProvider.notifier).state = false;
          } else {
            ref.read(isOpenProvider.notifier).state = true;
          }
        },
        leading: Icon(
          icon,
          color: context.colors.primary,
        ),
        title: Text(title),
        trailing: IconButton(
          onPressed: () {
            ref.read(isOpenProvider.notifier).state = !isOpen;
          },
          icon: Icon(
            !isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 30,
            color: context.colors.primary,
          ),
        ),
        children: <Widget>[
          const Divider(
            thickness: 1,
            height: 1,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                subtitle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: trailing != null
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(trailing!),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// isOpenProvider is a state provider for the [CustomExpansionTile] widget.
final isOpenProvider = StateProvider<bool>((ref) {
  return true;
});
