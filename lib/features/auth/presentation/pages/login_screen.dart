import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [LoginScreen] widget
class LoginScreen extends StatelessWidget {
  /// constructor call
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log in 👋',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                      Text(
                        'Ready to return to the shadows ?',
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const KTextField(
                        label: 'Email',
                        hintText: 'Email Address',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const KTextField(
                        label: 'Password',
                        hintText: 'Enter Password',
                        isObscured: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password ?'),
                        ),
                      ),
                      const Spacer(),
                      PrimaryButton(
                        text: 'Log in',
                        onPressed: () => context.go('/auth/profile-photo'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
