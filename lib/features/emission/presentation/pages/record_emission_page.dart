import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/emission/data/models/emission_model.dart';
import 'package:carbon_zero/features/emission/presentation/view_models/emission_view_model.dart';
import 'package:carbon_zero/features/emission/presentation/widgets/food_emission_form.dart';
import 'package:carbon_zero/features/emission/presentation/widgets/record_filled_button.dart';
import 'package:carbon_zero/features/emission/presentation/widgets/transport_emission_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will contain the form where the user can record an emission
class RecordEmissionPage extends ConsumerStatefulWidget {
  /// RecordEmissionPage constructor
  const RecordEmissionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecordEmissionPageState();
}

class _RecordEmissionPageState extends ConsumerState<RecordEmissionPage>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStreamProvider);
    final emissionVm = ref.watch(emissionViewModelProvider);
    final isLoading = emissionVm is AsyncLoading;
    ref.listen(emissionViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emission recorded successfully'),
            ),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error is Failure ? error.message : error.toString(),
                style: TextStyle(
                  color: context.colors.onError,
                ),
              ),
              backgroundColor: context.colors.error,
            ),
          );
        },
      );
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Record Emission'),
          bottom: TabBar(
            controller: controller,
            tabs: const [
              Tab(
                icon: Icon(Icons.food_bank),
                text: 'Food',
              ),
              Tab(
                icon: Icon(Icons.directions_transit),
                text: 'Transport',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: const [
            // food tab
            Padding(
              padding: EdgeInsets.all(4),
              child: FoodEmissionForm(),
            ),
            // transport tab
            TransportEmissionForm(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: RecordFilledButton(
          text: 'Record',
          currentTabIndex: controller.index,
          isLoading: isLoading,
          onPressed: () async {
            final type = controller.index == 0
                ? EmissionType.food
                : EmissionType.transport;
            if (user.value != null) {
              await ref
                  .read(emissionViewModelProvider.notifier)
                  .recordFoodEmission(type, user.value!.userId!);
            }
          },
        ),
      ),
    );
  }
}
