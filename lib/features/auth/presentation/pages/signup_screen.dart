// import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// simple [SignUpScreen] widget.
class SignUpScreen extends ConsumerStatefulWidget {
  /// create const instance of [SignUpScreen] widget.
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      final user = UserModel(
        fName: fNameController.text,
        lName: lNameController.text,
        email: emailController.text,
        activityIds: const [],
        communityIds: const [],
      );

      await ref
          .read(authViewModelProvider.notifier)
          .signUp(passwordController.text, user);
      fNameController.clear();
      lNameController.clear();
      emailController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.watch(authViewModelProvider);
    final isLoading = authViewModel is AsyncLoading;
    ref.listen(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        // error: (error, stackTrace) =>
        //     ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //   content: Text(error is Failure ? error.message : error.toString()),
        //   ),
        // ),
        data: (_) {
          final auth = ref.watch(authInstanceProvider);
          if (auth.currentUser?.uid != null) {
            context.go('/auth/profile-photo');
          }
        },
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: FormLayout(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
              ),
              Text(
                'Join th green revolution!',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20,
              ),
              KTextField(
                label: 'First Name',
                hintText: 'First Name',
                controller: fNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              KTextField(
                controller: lNameController,
                label: 'Last Name',
                hintText: 'Last Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              KTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'Email Address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
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
              // will only use country hence to change to drop down menu

              KTextField(
                controller: passwordController,
                label: 'Password',
                hintText: 'Enter Password',
                isObscured: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 50,
              ),

              PrimaryButton(
                text: 'Create Account',
                onPressed: !isLoading ? submit : null,
                isLoading: isLoading,
              ),

              const SizedBox(
                height: 50,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By Creating an account you agree tou our ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () async {
                          await openCustomTab(context, terms);
                        },
                        child: Text(
                          'Terms of Service',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () async {
                          await openCustomTab(context, privacyUrl);
                        },
                        child: Text(
                          'Privacy Policy',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
