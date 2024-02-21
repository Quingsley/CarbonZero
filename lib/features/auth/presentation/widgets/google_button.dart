import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Google sign in button widget
class GButton extends ConsumerWidget {
  /// Google sign in button widget
  const GButton({required this.text, required this.isLogin, super.key});

  /// label of the button
  final String text;

  /// checks if user is signing in or signing up
  final bool isLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final isLoading = authViewModel is AsyncLoading;
    ref.listen(authViewModelProvider, (prev, next) {
      next.whenOrNull(
        loading: () async {
          await showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              // insetPadding: EdgeInsets.zero,

              // backgroundColor: context.colors.primaryContainer,
              child: Builder(
                builder: (context) {
                  final height = MediaQuery.sizeOf(context).height;
                  final width = MediaQuery.sizeOf(context).width;
                  return SizedBox(
                    width: width * .01,
                    height: height * .1,
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      child: ColoredBox(
                        color: context.colors.primaryContainer,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        data: (_) {
          if (!isLogin) {
            context.go('/home');
          }
        },
      );
    });
    return ElevatedButton(
      onPressed: !isLoading
          ? () {
              ref
                  .read(authViewModelProvider.notifier)
                  .signInWithGoogle(isLogin: isLogin);
            }
          : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: context.colors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google.png',
            width: 25,
            height: 25,
            cacheHeight: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
