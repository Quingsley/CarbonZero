import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A reusable [KTextField] widget
class KTextField extends ConsumerWidget {
  /// constructor call
  const KTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isObscured = false,
    super.key,
  });

  /// label of the field
  final String label;

  /// hint text
  final String hintText;

  /// used for toggling password visibility
  final bool isObscured;

  /// controller for the text field
  final TextEditingController controller;

  /// validates the input
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPassword = ref.watch(showPasswordProvider);
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller,
            obscureText: !showPassword && isObscured,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              filled: false,
              enabledBorder: outlineInputBorder,
              border: outlineInputBorder,
              focusedBorder: outlineInputBorder.copyWith(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              focusedErrorBorder: outlineInputBorder.copyWith(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              errorBorder: outlineInputBorder.copyWith(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              suffixIcon: isObscured
                  ? IconButton(
                      onPressed: () {
                        ref.read(showPasswordProvider.notifier).state =
                            !showPassword;
                      },
                      icon: Icon(
                        showPassword
                            ? Icons.visibility_off_rounded
                            : Icons.remove_red_eye,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// A provider to toggle password visibility
final showPasswordProvider = StateProvider<bool>((ref) => false);
