import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// simple [AuthScreen] widget.
class AuthScreen extends StatefulWidget {
  /// create const instance of [AuthScreen] widget.
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Row(
                        children: [
                          Text(
                            'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/auth/sign-in'),
                            child: Text(
                              'Log in',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Join th green revolution!',
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const KTextField(label: 'Name', hintText: 'Full Name'),
                      const SizedBox(
                        height: 20,
                      ),
                      const KTextField(
                        label: 'Email',
                        hintText: 'Email Address',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // will only use country hence to change to drop down menu
                      const KTextField(
                        label: 'Location (Optional)',
                        hintText: 'Your Location',
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
                        height: 50,
                      ),
                      PrimaryButton(text: 'Create Account', onPressed: () {}),
                      const SizedBox(
                        height: 50,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By Creating an account you agree tou our ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
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
