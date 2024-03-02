import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// will update the user first name and last name
Future<void> updateUser(BuildContext ctx, UserModel user) async {
  return showDialog(
    context: ctx,
    builder: (context) {
      return UpdateUser(
        user: user,
      );
    },
  );
}

/// widget used to update the user
class UpdateUser extends ConsumerStatefulWidget {
  /// constructor call
  const UpdateUser({
    required this.user,
    super.key,
  });

  /// current user model
  final UserModel user;
  @override
  ConsumerState<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends ConsumerState<UpdateUser> {
  late final TextEditingController fNameController;
  late final TextEditingController lNameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userStreamProvider);
    fNameController = TextEditingController(text: user.value?.fName);
    lNameController = TextEditingController(text: user.value?.lName);
  }

  @override
  void dispose() {
    super.dispose();
    fNameController.dispose();
    lNameController.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      final updateUser = widget.user.copyWith(
        fName: fNameController.text,
        lName: lNameController.text,
      );
      await ref.read(authViewModelProvider.notifier).updateUser(updateUser);

      if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = ref.watch(authViewModelProvider);
    final isLoading = authVm is AsyncLoading;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.sizeOf(context).height * .4,
        child: Form(
          key: _formKey,
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
                hintText: widget.user.fName,
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
                hintText: widget.user.lName,
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
                onPressed: !isLoading ? submit : null,
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
