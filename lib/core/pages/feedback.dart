import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/auth/data/models/feedback_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will show the feedback page
class FeedBackPage extends ConsumerStatefulWidget {
  /// constructor call
  const FeedBackPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends ConsumerState<FeedBackPage> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final user = ref.read(userStreamProvider);
      final feedBack = FeedBackModel(
        message: controller.text,
        userId: user.value!.userId!,
      );
      // submit the feedback
      await ref.read(authViewModelProvider.notifier).collectFeedback(feedBack);
      if (mounted) Navigator.of(context).pop();
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = ref.watch(authViewModelProvider);
    final isLoading = authVm is AsyncLoading;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FormLayout(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Flexible(
                  child: KTextField(
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Provide feedback';
                      }
                      return null;
                    },
                    label: 'Speak your truth!',
                    hintText:
                        'Please provide your honest feedback about carbonZero',
                    controller: controller,
                  ),
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  isLoading: isLoading,
                  text: 'Submit',
                  onPressed: isLoading ? null : submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
