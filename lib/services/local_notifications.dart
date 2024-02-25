import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:cron/cron.dart';

/// contain static methods to handle local notifications
class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
    BuildContext context,
  ) async {
    // Your code goes here
    final json = receivedAction.payload?['activity'];
    print(json);
    if (json != null) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final activity = ActivityModel.fromJson(data);
      context.go('/activity-details', extra: activity);
    }
  }

  /// request for users permission to send local notifications
  static Future<void> requestForPermission(BuildContext context) async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Allow Notifications'),
              content: const Text(
                'We need your permission to send you local notifications',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    final isPermitted = await AwesomeNotifications()
                        .requestPermissionToSendNotifications();
                    if (context.mounted) Navigator.of(context).pop(isPermitted);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  /// schedule notification
  static Future<void> scheduleNotification(
    ActivityModel activity,
    BuildContext ctx,
  ) async {
// get current time
    final currentTime = DateTime.now();
// gt start date and end date
    final startDate = DateTime.parse(activity.startDate);
    final endDate = DateTime.parse(activity.endDate);
// compare current time with start date and date date to ensure that
//the activity is not over
    if (currentTime.isAfter(startDate) && currentTime.isBefore(endDate)) {
// if the activity is not over, schedule a notification
// time to schedule the notification 4: 47 PM
      final [hour, minute] = activity.reminderTime.split(':');
      final scheduleTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(hour),
        int.parse(minute),
      );
      // final cronExpression = Schedule(
      //   hours: int.parse(hour),
      //   minutes: int.parse(minute),
      //   seconds: 0,
      // ).toCronString();
      // final preciseDates = generateDateRange(startDate, endDate);
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'basic_channel',
          groupKey: 'basic_channel_group',
          title: activity.name,
          body:
              'Its time to add a completion on ${activity.name} to your daily activities.',
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.BigText,
          backgroundColor: ctx.colors.primary,
          color: ctx.colors.onPrimary,
          payload: {'activity': jsonEncode(activity.toJson())},
          autoDismissible: false,
          bigPicture: activity.icon,
        ),
        schedule: NotificationCalendar(
          day: scheduleTime.day,
          hour: scheduleTime.hour,
          minute: scheduleTime.minute,
          month: scheduleTime.month,
          year: scheduleTime.year,
          weekday: scheduleTime.weekday,
        ),
      );
    }
  }

  /// will generate a list of date range between the start date and end date
  static List<DateTime> generateDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final dates = <DateTime>[];

    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }

    return dates;
  }
}



// NotificationAndroidCrontab(
//           initialDateTime: DateTime.parse(activity.startDate),
//           expirationDateTime: DateTime.parse(activity.endDate),
//           crontabExpression: test,
//           preciseSchedules: preciseDates,
//         )

// NotificationCalendar.fromDate(date: scheduleTime)