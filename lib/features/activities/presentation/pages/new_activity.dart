import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/constants/icon_pack.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/presentation/providers/activities_providers.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/color_picker.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/icon_button.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/icon_pack_grid.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// class used to create a new activity
class NewActivity extends ConsumerStatefulWidget {
  /// [NewActivity] constructor
  const NewActivity({required this.type, super.key});

  /// either user / community
  final ActivityType type;

  @override
  ConsumerState<NewActivity> createState() => _NewActivityState();
}

class _NewActivityState extends ConsumerState<NewActivity> {
  final _formKey = GlobalKey<FormState>();
  final goalNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController =
      TextEditingController(text: DateTime.now().toIso8601String());
  final endDateController = TextEditingController(
    text: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
  );
  final reminderTimeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    goalNameController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    reminderTimeController.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate();
    final color = ref.read(selectedColorProvider);
    final icon = ref.read(selectedIconProvider);
    final user = ref.read(userStreamProvider);
    if (color == null || icon == null) {
      ref.read(showErrorProvider.notifier).state = true;
      return;
    }
    ref.read(showErrorProvider.notifier).state = false;
    if (isValid != null && isValid) {
      final activity = ActivityModel(
        startDate: startDateController.text,
        endDate: endDateController.text,
        name: goalNameController.text,
        description: descriptionController.text,
        type: widget.type,
        parentId: user.value!.userId!,
        icon: icon,
        color: color,
        reminderTime: reminderTimeController.text,
      );

      goalNameController.clear();
      descriptionController.clear();
      ref.read(selectedColorProvider.notifier).state = null;
      ref.read(selectedIconProvider.notifier).state = null;

      await ref
          .read(activityViewModelProvider.notifier)
          .createActivity(activity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(selectedColorProvider);
    final icon = ref.watch(selectedIconProvider);
    final showErrColor = ref.watch(showErrorProvider);
    final activityVm = ref.watch(activityViewModelProvider);
    final isLoading = activityVm is AsyncLoading;
    ref.listen(activityViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal created successfully')),
          );
        },
        loading: () async {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Dialog(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: context.colors.error,
              content: const Text('Goal not created please try again'),
            ),
          );
        },
      );
    });
    return FormLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: !isLoading
                      ? () {
                          Navigator.of(context).pop();
                          ref.read(selectedIconProvider.notifier).state = null;
                          ref.read(selectedColorProvider.notifier).state = null;
                          ref.read(showErrorProvider.notifier).state = false;
                        }
                      : null,
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'New Goal',
                  style: context.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: isLoading ? null : submit,
                  icon: const Icon(Icons.check_circle_outlined),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            KTextField(
              label: 'Name',
              hintText: 'Meatless Month',
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please provide a valid name';
                }
                return null;
              },
              controller: goalNameController,
            ),
            const SizedBox(
              height: 8,
            ),
            KTextField(
              label: 'Description',
              hintText: '',
              controller: descriptionController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please provide a valid description';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: KIconButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        firstDate: now,
                        errorInvalidText: 'Please pick a valid date',
                        lastDate: now.add(const Duration(days: 30)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          startDateController.text =
                              pickedDate.toIso8601String();
                        });
                      }
                    },
                    icon: Icons.calendar_today,
                    label:
                        'Start date:${DateFormat('dd/MM/yyyy').format(DateTime.parse(startDateController.text))}',
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: KIconButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        errorInvalidText: 'Please pick a valid date',
                        // minimum is 7 days from start date which is now
                        firstDate: now.add(const Duration(days: 7)),
                        lastDate: now.add(const Duration(days: 90)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          endDateController.text = pickedDate.toIso8601String();
                        });
                      }
                    },
                    icon: Icons.calendar_month,
                    label:
                        'End date ${DateFormat('dd/MM/yyyy').format(DateTime.parse(endDateController.text))}',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            KIconButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    reminderTimeController.text = pickedTime.format(context);
                  });
                }
              },
              icon: Icons.add_alarm_rounded,
              label: 'Reminder ${reminderTimeController.text}',
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Pick an icon',
              style: TextStyle(
                color:
                    icon == null && showErrColor ? context.colors.error : null,
              ),
            ),
            SizedBox(
              height: 130,
              child: IconPack(
                icons: ecoFriendlyIcons,
                isMain: true,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  context.push('/home/icons');
                },
                child: const Text('More Icons'),
              ),
            ),
            Text(
              'Color',
              style: TextStyle(
                color:
                    color == null && showErrColor ? context.colors.error : null,
              ),
            ),
            const ColorPicker(),
          ],
        ),
      ),
    );
  }
}

/// will highlight the text
final showErrorProvider = StateProvider<bool>((ref) {
  return false;
});
