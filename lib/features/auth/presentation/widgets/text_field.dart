import 'package:flutter/material.dart';

/// A reusable [KTextField] widget
class KTextField extends StatefulWidget {
  /// constructor call
  const KTextField({
    required this.label,
    required this.hintText,
    this.isObscured = false,
    super.key,
  });

  /// label of the field
  final String label;

  /// hint text
  final String hintText;

  /// used for toggling password visibility
  final bool isObscured;

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
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
            widget.label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            obscureText: !showPassword && widget.isObscured,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              filled: false,
              enabledBorder: outlineInputBorder,
              border: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              suffixIcon: widget.isObscured
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
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
