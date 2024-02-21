import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// return a bottom sheet with the given child widget
Future<void> kShowBottomSheet(
  BuildContext context,
  Widget child, [
  double? height,
]) {
  return showMaterialModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: context.colors.surface,
    builder: (context) => Container(
      margin: const EdgeInsets.all(12),
      height: height ?? MediaQuery.sizeOf(context).height * .4,
      child: child,
    ),
  );
}
