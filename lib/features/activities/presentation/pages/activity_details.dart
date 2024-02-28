import 'dart:collection';

import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:carbon_zero/core/widgets/bottom_sheet.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:carbon_zero/features/activities/data/repositories/activity_repository.dart';
import 'package:carbon_zero/features/activities/presentation/pages/record_activity.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/add_activity_btn.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:table_calendar/table_calendar.dart';

/// will contain the list of activity recordings
class ActivityDetails extends ConsumerStatefulWidget {
  /// constructor
  const ActivityDetails({required this.activityModel, super.key});

  /// activity model retrieved from local notification
  final ActivityModel activityModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ActivityDetailsState();
}

class _ActivityDetailsState extends ConsumerState<ActivityDetails> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  var _calendarFormat = CalendarFormat.twoWeeks;
  final ValueNotifier<LinkedHashMap<DateTime, List<ActivityRecordingModel>>>
      _events =
      ValueNotifier<LinkedHashMap<DateTime, List<ActivityRecordingModel>>>(
    LinkedHashMap<DateTime, List<ActivityRecordingModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    ),
  );

  void getEvents(DateTime day) {
    Future.delayed(Duration.zero, () async {
      final events = LinkedHashMap<DateTime, List<ActivityRecordingModel>>(
        equals: isSameDay,
        hashCode: getHashCode,
      );
      final data = await ref
          .read(
            activityRepositoryProvider,
          )
          .getActivityRecordings(widget.activityModel.id!, day);
      for (final recording in data) {
        final eventDate = DateTime.parse(recording.date);
        if (!events.containsKey(eventDate)) {
          events[eventDate] = [];
        }
        events[eventDate]?.add(recording);
      }
      _events.value = events;
    });
  }

  @override
  void initState() {
    super.initState();
    getEvents(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    final getSingleActivityAsyncValue =
        ref.watch(getSingleActivityProvider(widget.activityModel.id!));
    final getEventsForTheDay = ref.watch(
      getActivityRecodingFutureProvider(
        (widget.activityModel.id!, _selectedDay),
      ),
    );
    final user = ref.watch(userStreamProvider);
    return Scaffold(
      body: getSingleActivityAsyncValue.when(
        data: (activity) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight:
                    activity.type == ActivityType.individual ? 200 : 300,
                floating: true,
                snap: true,
                backgroundColor: context.colors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    '${activity.type == ActivityType.individual ? activity.icon : ''} ${activity.name}',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: activity.type == ActivityType.individual
                          ? context.colors.onPrimary
                          : context.colors.secondary,
                    ),
                  ),
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      image: activity.type == ActivityType.community
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              opacity: .62,
                              isAntiAlias: true,
                              colorFilter: ColorFilter.mode(
                                context.colors.primary,
                                BlendMode.dstIn,
                              ),
                              image: FirebaseImageProvider(
                                FirebaseUrl(activity.icon),
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${activity.carbonPoints}\ncarbon points',
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: activity.type == ActivityType.individual
                                  ? context.colors.onPrimary
                                  : context.colors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: SleekCircularSlider(
                            initialValue:
                                (activity.progress * 100).floorToDouble(),
                            appearance: CircularSliderAppearance(
                              customColors: CustomSliderColors(
                                trackColor: context.colors.tertiary,
                                progressBarColor:
                                    context.colors.primaryContainer,
                              ),
                              infoProperties: InfoProperties(
                                topLabelText: 'Progress',
                                topLabelStyle:
                                    context.textTheme.labelLarge?.copyWith(
                                  color:
                                      activity.type == ActivityType.individual
                                          ? context.colors.onPrimary
                                          : context.colors.secondary,
                                ),
                                mainLabelStyle:
                                    context.textTheme.displaySmall?.copyWith(
                                  color:
                                      activity.type == ActivityType.individual
                                          ? context.colors.onPrimary
                                          : context.colors.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: Text(
                            '${activity.cO2Emitted}\nCO2g emitted',
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: activity.type == ActivityType.individual
                                  ? context.colors.onPrimary
                                  : context.colors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Description: ${activity.description}',
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                    TableCalendar<ActivityRecordingModel>(
                      calendarFormat: _calendarFormat,
                      calendarStyle: CalendarStyle(
                        rangeHighlightColor: context.colors.primaryContainer,
                        todayDecoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      currentDay: _selectedDay,
                      firstDay: DateTime.parse(activity.startDate),
                      lastDay: DateTime.parse(activity.endDate),
                      rangeStartDay: DateTime.parse(activity.startDate),
                      rangeEndDay: DateTime.parse(activity.endDate),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay =
                                focusedDay; // update `_focusedDay` here as well
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      eventLoader: (day) {
                        getEvents(day);

                        return _events.value[day] ?? [];
                      },
                    ),
                    getEventsForTheDay.when(
                      data: (data) {
                        final hasUserRecordedActivity = data
                            .map((recording) => recording.userId)
                            .contains(user.value?.userId);
                        if (data.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text('No activity recorded for the day'),
                                AddActivityBtn(
                                  onPressed: _recordActivity,
                                  label: "Record today 's activity",
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              if (activity.type == ActivityType.community &&
                                  !hasUserRecordedActivity)
                                AddActivityBtn(
                                  onPressed: _recordActivity,
                                  label: 'Record Activity',
                                ),
                              for (final recording in data)
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FirebaseImageProvider(
                                      FirebaseUrl(recording.imageUrl),
                                    ),
                                  ),
                                  title: Text(
                                    'Recorded by: ${recording.userName}',
                                  ),
                                  subtitle: Text(
                                    recording.description,
                                  ),
                                ),
                            ],
                          );
                        }
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text(
                            error is Failure ? error.message : error.toString(),
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => const Center(
          child: CircularProgressIndicator(),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _recordActivity() async {
    if (isSameDay(
      _selectedDay,
      DateTime.now(),
    )) {
      await kShowBottomSheet(
        context: context,
        height: MediaQuery.sizeOf(context).height * .7,
        child: RecordActivity(
          activityModel: widget.activityModel,
          selectedDate: _selectedDay,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can only record activity for today',
          ),
        ),
      );
    }
  }
}
