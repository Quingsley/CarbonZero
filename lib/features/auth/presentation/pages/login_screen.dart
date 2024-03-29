import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/google_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [LoginScreen] widget
class LoginScreen extends ConsumerStatefulWidget {
  /// constructor call
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelProvider.notifier).signIn(
            emailController.text,
            passwordController.text,
          );
      emailController.clear();
      passwordController.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.watch(authViewModelProvider);
    final isLoading = authViewModel is AsyncLoading;
    final isGButton = ref.watch(isGoogleButtonProvider);
    ref.listen(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: context.colors.error,
              content:
                  Text(error is Failure ? error.message : error.toString()),
            ),
          );
        },
        data: (_) {
          final auth = ref.read(authInstanceProvider);
          if (auth.currentUser?.uid != null) {
            context.go('/home');
          }
        },
      );
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: FormLayout(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Log in 👋',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push('/user-onboarding'),
                    child: Text(
                      'Sign Up',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                              ),
                    ),
                  ),
                ],
              ),
              Text(
                'Ready to return to the shadows ?',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 50,
              ),
              KTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'Email Address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide your email';
                  }
                  if (!isEmailValid(value)) {
                    return 'Please provide a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              KTextField(
                controller: passwordController,
                label: 'Password',
                hintText: 'Enter Password',
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                isObscured: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => context.go('/auth/forgot-password'),
                  child: const Text('Forgot Password ?'),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Log in',
                onPressed: !isLoading ? submit : null,
                isLoading: isLoading && !isGButton,
              ),
              const GButton(
                text: 'Continue with Google',
                isLogin: true,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
