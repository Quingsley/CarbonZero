import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// will update the user first name and last name
Future<void> updateUser(
  BuildContext context,
  UserModel? user,
  WidgetRef ref,
) async {
  final fNameController = TextEditingController(text: user?.fName);
  final lNameController = TextEditingController(text: user?.lName);
  final viewModel = ref.read(authViewModelProvider);
  final isLoading = viewModel is AsyncLoading;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.sizeOf(context).height * .4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Names',
                style: context.textTheme.headlineMedium,
              ),
              KTextField(
                label: 'First Name',
                hintText: user?.fName ?? '',
                controller: fNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter a valid name';
                  }
                  return null;
                },
              ),
              KTextField(
                label: 'Last Name',
                hintText: user?.lName ?? '',
                controller: lNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter a valid name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                text: 'Save',
                isLoading: isLoading,
                onPressed: !isLoading
                    ? () async {
                        final updateUser = user?.copyWith(
                          fName: fNameController.text,
                          lName: lNameController.text,
                        );
                        await ref
                            .read(authViewModelProvider.notifier)
                            .updateUser(updateUser!);
                        if (context.mounted) context.pop();
                      }
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    },
  );
}
