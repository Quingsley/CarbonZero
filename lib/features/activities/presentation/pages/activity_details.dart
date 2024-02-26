import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/bottom_sheet.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:carbon_zero/features/activities/presentation/pages/record_activity.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
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
  @override
  Widget build(BuildContext context) {
    final getEventsForTheDay = ref.watch(
      getActivityRecodingFutureProvider(
        (widget.activityModel.id!, _selectedDay),
      ),
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            // pinned: true,
            floating: true,
            snap: true,
            backgroundColor: context.colors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.activityModel.icon} ${widget.activityModel.name}',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.activityModel.carbonPoints}\ncarbon points',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: SleekCircularSlider(
                      initialValue:
                          (widget.activityModel.progress * 100).floorToDouble(),
                      appearance: CircularSliderAppearance(
                        customColors: CustomSliderColors(
                          trackColor: context.colors.tertiary,
                          progressBarColor: context.colors.primaryContainer,
                        ),
                        infoProperties: InfoProperties(
                          topLabelText: 'Progress',
                          topLabelStyle: context.textTheme.labelLarge,
                          mainLabelStyle: context.textTheme.displaySmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: Text(
                      '${widget.activityModel.cO2Emitted}\nCO2g emitted',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Description: ${widget.activityModel.description}',
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                TableCalendar<ActivityRecordingModel>(
                  calendarStyle: CalendarStyle(
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
                  firstDay: DateTime.parse(widget.activityModel.startDate),
                  lastDay: DateTime.parse(widget.activityModel.endDate),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: (day) {
                    return [];
                  },
                ),
                getEventsForTheDay.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('No activity recorded for the day'),
                            FilledButton.icon(
                              onPressed: () async {
                                if (isSameDay(_selectedDay, DateTime.now())) {
                                  await kShowBottomSheet(
                                    context: context,
                                    height:
                                        MediaQuery.sizeOf(context).height * .7,
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
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Record today 's activity"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: data
                            .map(
                              (e) => ListTile(
                                leading: CircleAvatar(
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    debugPrint(exception.toString());
                                  },
                                  backgroundImage: e.imageUrl.isNotEmpty
                                      ? FirebaseImageProvider(
                                          FirebaseUrl(e.imageUrl),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  e.description,
                                ),
                              ),
                            )
                            .toList(),
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
      ),
    );
  }
}
