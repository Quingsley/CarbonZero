import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// used when the user has forgotten the password
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  /// constructor
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      await ref
          .read(authViewModelProvider.notifier)
          .forgotPassword(emailController.text);
      emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = authViewModelProvider is AsyncLoading;

    ref.listen(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(error is Failure ? error.message : error.toString()),
            ),
          );
        },
        data: (_) async {
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text(
                'An email has been sent to the provided email to reset your passowrd',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context
                      ..pop()
                      ..go('/auth');
                  },
                  child: const Text('Proceed'),
                ),
              ],
            ),
          );
        },
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Forgot Password'),
              const SizedBox(
                height: 12,
              ),
              KTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                text: 'Continue',
                onPressed: submit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
