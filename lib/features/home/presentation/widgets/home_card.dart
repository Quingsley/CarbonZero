import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// A [HomeCard] that take the [title], [description] and [IconData][icon]
class HomeCard extends StatelessWidget {
  /// constructor call
  const HomeCard({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  /// [title] of the card
  final String? title;

  /// [description of the card]
  final String description;

  /// [icon] of the card
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.inversePrimary,
      child: ListTile(
        leading: CircleAvatar(
          // backgroundColor: context.colors.background,
          // radius: 16,
          child: Icon(
            icon,
            // color: context.colors.onBackground,
          ),
        ),
        title: Text(
          title ?? description,
          textAlign: TextAlign.left,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: title != null
            ? Text(
                description,
                style: context.textTheme.labelSmall
                    ?.copyWith(color: context.colors.onPrimary),
              )
            : null,
      ),
    );
  }
}

// Container(
//         padding = const EdgeInsets.only(top: 8, bottom: 8, right: 2),
//         child = Row(
//           mainAxisSize: MainAxisSize.min,
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: CircleAvatar(
//                 backgroundColor: context.colors.background,
//                 radius: 16,
//                 child: Icon(
//                   icon,
//                   color: context.colors.primaryContainer,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: titleLarge != null ? 2 : 1,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title ?? description,
//                     textAlign: TextAlign.left,
//                     style: context.textTheme.labelMedium?.copyWith(
//                       color: context.colors.onPrimary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (title != null)
//                     Text(
//                       description,
//                       style: context.textTheme.labelSmall
//                           ?.copyWith(color: context.colors.onPrimary),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )
