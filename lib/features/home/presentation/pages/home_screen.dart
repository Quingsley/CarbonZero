import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/widgets/bottom_sheet.dart';
import 'package:carbon_zero/features/activities/presentation/pages/new_activity.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:carbon_zero/features/home/presentation/widgets/activity_tile.dart';
import 'package:carbon_zero/features/home/presentation/widgets/carbon_foot_print.dart';
import 'package:carbon_zero/features/home/presentation/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool isDay = true;
  final _fabKey = GlobalKey<ExpandableFabState>();
  List<CommunityModel> communities = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDaytime();
  }

  @override
  void initState() {
    super.initState();

    final messagingInstance = ref.read(firebaseMessagingProvider);
    messagingInstance.onTokenRefresh.listen((token) async {
      final user = ref.read(userStreamProvider);
      if (user.value != null) {
        final isPresent = user.value!.pushTokens.contains(token);
        if (!isPresent) {
          await ref
              .read(authRepositoryProvider)
              .updatePushToken(token, user.value!.userId!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStreamProvider);
    // ignore: cascade_invocations
    user.whenOrNull(
      data: (user) {
        if (user != null) {
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
                          crossFadeState: isDay
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
                    if (user.value?.photoId != null)
                      GestureDetector(
                        onTap: () => context.go('/settings'),
                        child: user.when(
                          error: (_, __) => const SizedBox.shrink(),
                          loading: () => const CircularProgressIndicator(),
                          data: (value) => CircleAvatar(
                            backgroundImage:
                                NetworkImage(user.value?.photoId ?? ''),
                          ),
                        ),
                      )
                    else
                      IconButton.filled(
                        onPressed: () => context.go('/settings'),
                        icon: const Icon(Icons.person),
                      ),
                  ],
                ),
              ],
            ),
            const Text('Hope you  planted a tree today'),
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
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: HomeCard(
                    title: 'Reach to goal',
                    description: '9453 co2',
                    icon: Icons.line_axis,
                  ),
                ),
                Expanded(
                  child: HomeCard(
                    title: 'Community goal',
                    description: '10489 co2',
                    icon: Icons.people,
                  ),
                ),
              ],
            ),
            const HomeCard(
              title: null,
              description: '''
Using reusable bags instead of plastic bags when shopping can help reduce 
carbon emissions by reducing the amount of plastic waste produced''',
              icon: Icons.lightbulb,
            ),
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
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
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
          builder: (context, onPressed, progress) {
            return FloatingActionButton(
              heroTag: null,
              onPressed: onPressed,
              child: const Icon(Icons.add),
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
                height: MediaQuery.sizeOf(context).height * .9,
                isDismissible: false,
              );
            },
            heroTag: null,
            label: const Text('New Activity'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Record emission'),
            onPressed: () {},
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
                    height: MediaQuery.sizeOf(context).height * .9,
                    isDismissible: false,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /// checks  if it is day or night
  void isDaytime() {
    final now = DateTime.now();
    final currentHour = now.hour;

    // Assuming daytime is between 6 AM and 6 PM, adjust the range as needed
    setState(() {
      isDay = currentHour >= 6 && currentHour < 18;
    });
  }
}
