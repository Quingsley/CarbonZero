import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/constants/icon_pack.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/widgets/add_image_container.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/notification_tile.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/presentation/providers/activities_providers.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/color_picker.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/icon_button.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/icon_pack_grid.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:carbon_zero/services/local_notifications.dart';
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
  final imageController = TextEditingController();
  final startDateController =
      TextEditingController(text: DateTime.now().toIso8601String());
  final endDateController = TextEditingController(
    text: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
  );

  final reminderTimeController = TextEditingController();
  final communityController = TextEditingController();

  List<CommunityModel> communities = [];
  String? selectedCommunityId;

  @override
  void initState() {
    super.initState();

    final user = ref.read(userStreamProvider);
    final adminCommunitiesAsyncValue =
        ref.read(adminCommunityFutureProvider(user.value!.userId!));
    final adminCommunities = adminCommunitiesAsyncValue.value;
    if (adminCommunities != null) {
      communities = adminCommunities;
      if (communities.isNotEmpty) selectedCommunityId = communities.first.id;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ecoFriendlyColors.shuffle();
    reminderTimeController.text = TimeOfDay.now().format(context);
  }

  @override
  void dispose() {
    super.dispose();
    goalNameController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    reminderTimeController.dispose();
    communityController.dispose();
    imageController.dispose();
  }

  Future<void> submit() async {
    ref.read(showErrorProvider.notifier).state = false;
    final isValid = _formKey.currentState?.validate();
    final color = ref.read(selectedColorProvider);
    final icon = ref.read(selectedIconProvider);
    final user = ref.read(userStreamProvider);
    final imageCondition =
        imageController.text.isEmpty && widget.type == ActivityType.community;
    if (color == null ||
        (icon == null && widget.type == ActivityType.individual) ||
        imageCondition) {
      ref.read(showErrorProvider.notifier).state = true;
      return;
    }
    final startDate = DateTime.parse(startDateController.text);
    final endDate = DateTime.parse(endDateController.text);
    if (endDate.isBefore(startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: const Text('End date cannot be before the start date'),
        ),
      );
      return;
    }

    ref.read(showErrorProvider.notifier).state = false;
    if (isValid != null && isValid) {
      final activity = ActivityModel(
        startDate: startDate.toUtc().toIso8601String(),
        endDate: endDate.toUtc().toIso8601String(),
        name: goalNameController.text,
        description: descriptionController.text,
        type: widget.type,
        parentId: widget.type == ActivityType.individual
            ? user.value!.userId!
            : selectedCommunityId!,
        icon: widget.type == ActivityType.individual
            ? icon!
            : imageController.text,
        color: color,
        reminderTime: reminderTimeController.text,
        participants:
            // add the challenge creator (admin) to the list of participants
            widget.type == ActivityType.community ? [user.value!.userId!] : [],
      );

      goalNameController.clear();
      reminderTimeController.clear();
      descriptionController.clear();
      imageController.clear();
      ref.read(selectedColorProvider.notifier).state = null;
      ref.read(selectedIconProvider.notifier).state = null;

      await ref
          .read(activityViewModelProvider.notifier)
          .createActivity(activity);

      if (mounted) {
        await NotificationController.scheduleNotification(activity);
      }
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal created successfully')),
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
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
        title: Text(
          'New ${widget.type == ActivityType.community ? "Community" : ''} Goal',
          style: widget.type == ActivityType.community
              ? context.textTheme.titleMedium
              : context.textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            label: const Text('Save'),
            onPressed: isLoading ? null : submit,
            icon: isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.check_circle_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FormLayout(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.type == ActivityType.community)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.type == ActivityType.community)
                  DropdownMenu<CommunityModel>(
                    initialSelection: communities.first,
                    label: const Text('Community'),
                    inputDecorationTheme: InputDecorationTheme(
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedErrorBorder: outlineInputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      errorBorder: outlineInputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    width: MediaQuery.sizeOf(context).width * .89,
                    helperText: 'Please select a community',
                    onSelected: (community) {
                      if (community != null) {
                        setState(() {
                          communityController.text = community.name;
                          selectedCommunityId = community.id;
                        });
                      }
                    },
                    leadingIcon: const Icon(Icons.group),
                    controller: communityController,
                    dropdownMenuEntries: communities
                        .map(
                          (community) => DropdownMenuEntry(
                            value: community,
                            label: community.name,
                          ),
                        )
                        .toList(),
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
                              endDateController.text =
                                  pickedDate.toIso8601String();
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: KIconButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                reminderTimeController.text =
                                    pickedTime.format(context);
                              });
                            }
                          },
                          icon: Icons.add_alarm_rounded,
                          label: 'Reminder ${reminderTimeController.text}',
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Expanded(
                        child: NtfTile(),
                      ),
                    ],
                  ),
                ),
                ...switch (widget.type) {
                  ActivityType.individual => [
                      Text(
                        'Pick an icon',
                        style: TextStyle(
                          color: icon == null && showErrColor
                              ? context.colors.error
                              : null,
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
                    ],
                  ActivityType.community => [
                      const SizedBox(height: 4),
                      AddImageContainer(
                        imageType: ImageType.community,
                        imageController: imageController,
                        showError: showErrColor,
                        containerLabel: 'Add a poster for your community goal',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                },
                Text(
                  'Pick a Color for your Goal',
                  style: TextStyle(
                    color: color == null && showErrColor
                        ? context.colors.error
                        : null,
                  ),
                ),
                const ColorPicker(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
