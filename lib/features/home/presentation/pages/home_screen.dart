import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:carbon_zero/core/widgets/bottom_sheet.dart';
import 'package:carbon_zero/core/widgets/home_loading_skeleton.dart';
import 'package:carbon_zero/features/activities/presentation/pages/new_activity.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:carbon_zero/features/home/presentation/widgets/activity_tile.dart';
import 'package:carbon_zero/features/home/presentation/widgets/carbon_foot_print.dart';
import 'package:carbon_zero/features/home/presentation/widgets/carousel.dart';
import 'package:carbon_zero/features/home/presentation/widgets/home_card.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// [HomeScreen] the home tab of the app contains activities like
/// the carbon footprint of the user, daily goals, community goal daily tip ,
///  latest activities
class HomeScreen extends ConsumerStatefulWidget {
  /// constructor call
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _fabKey = GlobalKey<ExpandableFabState>();
  List<CommunityModel> communities = [];
  final List<RemoteMessage> _tips = [];

  @override
  void initState() {
    super.initState();
    final notifications = ref.read(notificationMessagesProvider);
    _tips.addAll(
      notifications.where((message) => message.data['type'] == 'tip'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeStateProvider);
    final user = ref.watch(userStreamProvider);
    // ignore: cascade_invocations
    user.whenOrNull(
      data: (user) {
        if (user != null) {
          checkPushToken(ref, user);
          final communities =
              ref.watch(adminCommunityFutureProvider(user.userId!));
          setState(() {
            this.communities = communities.value ?? [];
          });
        }
      },
    );
    final activitiesAsyncValue = ref.watch(
      getActivitiesStreamProvider(
        (user.value?.userId, ActivityType.individual),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    text: 'Hi ',
                    children: [
                      TextSpan(
                        text: user.value?.fName ?? 'there',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                      WidgetSpan(
                        child: AnimatedCrossFade(
                          duration: const Duration(seconds: 1),
                          crossFadeState: !isDarkMode
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          sizeCurve: Curves.easeIn,
                          firstChild: Icon(
                            Icons.light_mode,
                            color: Colors.amberAccent.shade700,
                          ),
                          secondChild: const Icon(
                            Icons.dark_mode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: context.colors.primary,
                      onPressed: () => context.push('/notification'),
                      icon: const Icon(Icons.notifications),
                    ),
                    // if (user.value?.photoId != null)
                    Skeletonizer(
                      enabled: user.value?.photoId == null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Skeleton.replace(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            onTap: () => context.go('/settings'),
                            child: user.when(
                              error: (_, __) => const SizedBox.shrink(),
                              loading: () => const CircularProgressIndicator(),
                              data: (value) => CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.value?.photoId ?? ''),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // else
                    //   IconButton.filled(
                    //     onPressed: () => context.go('/settings'),
                    //     icon: const Icon(Icons.person),
                    //   ),
                  ],
                ),
              ],
            ),
            Text(
              user.value?.welcomeMessage ?? 'Hope you  planted a tree today',
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              child: CarbonFootPrintData(
                value: user.value?.carbonFootPrintNow ?? 0,
                per: 'month',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: HomeCard(
                    title: 'Reach to goal',
                    description:
                        '${user.value?.footPrintGoal.toStringAsFixed(2)} kg CO2e',
                    icon: Icons.line_axis,
                  ),
                ),
                Expanded(
                  child: HomeCard(
                    title: 'Community goal',
                    description:
                        '${user.value?.communityGoal.toStringAsFixed(2)} kg CO2e',
                    icon: Icons.people,
                  ),
                ),
              ],
            ),
            if (_tips.isEmpty)
              const HomeCard(
                title: null,
                description: '''
Using reusable bags instead of plastic bags when shopping can help reduce 
carbon emissions by reducing the amount of plastic waste produced''',
                icon: Icons.lightbulb,
              ),
            if (_tips.isNotEmpty && _tips.length == 1)
              HomeCard(
                title: _tips.first.notification!.title,
                description: _tips.first.notification!.body!,
                icon: Icons.lightbulb,
              ),
            if (_tips.isNotEmpty && _tips.length > 1)
              HomeCarousel(itemCount: _tips.length, tips: _tips),
            const SizedBox(
              height: 4,
            ),
            const Text('Latest activities'),
            Expanded(
              child: activitiesAsyncValue.when(
                data: (activities) {
                  if (activities.isEmpty) {
                    return const Center(child: Text('Please create a goal'));
                  } else {
                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return ActivityTile(
                          activity: activities[index],
                        );
                      },
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
                loading: HomeLoadingSkeleton.new,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _fabKey,
        type: ExpandableFabType.up,
        overlayStyle: ExpandableFabOverlayStyle(
          color: context.colors.primary.withOpacity(.62),
        ),
        openButtonBuilder: FloatingActionButtonBuilder(
          size: 16,
          builder: (_, onPressed, progress) {
            return FloatingActionButton(
              backgroundColor: context.colors.primary,
              heroTag: null,
              onPressed: onPressed,
              child: Icon(Icons.add, color: context.colors.onPrimary),
            );
          },
        ),
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final state = _fabKey.currentState;
              if (state != null) state.toggle();
              await kShowBottomSheet(
                context: context,
                child: const NewActivity(type: ActivityType.individual),
                isDismissible: false,
                isFullScreen: true,
              );
            },
            heroTag: null,
            label: const Text('New Activity'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Record emission'),
            onPressed: () async {
              final state = _fabKey.currentState;
              if (state != null) state.toggle();
              // final firebaseMessaging = ref.read(firebaseMessagingProvider);
              // final token = await firebaseMessaging.getToken();
              // print(token);
              await context.push('/home/record-emission');
            },
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Community challenge'),
            onPressed: () async {
              if (user.value != null) {
                if (communities.isNotEmpty) {
                  final state = _fabKey.currentState;
                  if (state != null) state.toggle();
                  await kShowBottomSheet(
                    context: context,
                    child: const NewActivity(type: ActivityType.community),
                    isDismissible: false,
                    isFullScreen: true,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'You do not own any communities yet, create one to create a community challenge.',
                      ),
                      action: SnackBarAction(
                        label: 'Create',
                        onPressed: () {
                          final state = _fabKey.currentState;
                          if (state != null) state.toggle();
                          context.go('/community/add-community');
                        },
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
