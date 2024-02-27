import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/widgets/add_image_container.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/services/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will have the form to record a new activity
class RecordActivity extends ConsumerStatefulWidget {
  /// constructor
  const RecordActivity({
    required this.activityModel,
    required this.selectedDate,
    super.key,
  });

  /// activity model
  final ActivityModel activityModel;

  /// selected date
  final DateTime selectedDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecordActivityState();
}

class _RecordActivityState extends ConsumerState<RecordActivity> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    imageController.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate();
    final user = ref.read(userStreamProvider);
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      final recordedActivity = ActivityRecordingModel(
        activityId: widget.activityModel.id!,
        parentId: widget.activityModel.parentId,
        date: widget.selectedDate.toIso8601String(),
        description: descriptionController.text,
        imageUrl: imageController.text,
        userId: user.value!.userId!,
        userName: user.value!.fName,
      );

      await ref
          .read(activityViewModelProvider.notifier)
          .recordActivity(recordedActivity, widget.activityModel.type);
      descriptionController.clear();
      imageController.clear();
      ref
        ..invalidate(getSingleActivityProvider)
        ..invalidate(getActivityRecodingFutureProvider);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityVm = ref.watch(activityViewModelProvider);
    final isLoadingActivityVm = activityVm is AsyncLoading;
    ref.listen(imageServiceProvider, (previous, next) {
      next.whenOrNull(
        data: (url) {
          imageController.text = url!;
        },
      );
    });
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Record ${widget.activityModel.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // const Spacer(),
              TextButton.icon(
                icon: isLoadingActivityVm
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.check_circle_outlined),
                onPressed: isLoadingActivityVm ? null : submit,
                label: const Text('Save'),
              ),
            ],
          ),
          KTextField(
            label: 'Description',
            hintText: 'Today I ${widget.activityModel.description}',
            controller: descriptionController,
            maxLines: 6,
            validator: (val) {
              if (val == null || val.length < 5) {
                return 'Please provide a valid description (min 5 characters)';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          AddImageContainer(
            imageController: imageController,
            containerLabel: 'Provide an image to earn more points',
            imageType: ImageType.activity,
          ),
        ],
      ),
    );
  }
}
