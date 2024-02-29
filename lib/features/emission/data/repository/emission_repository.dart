import 'package:carbon_zero/features/emission/data/data_source/emission_data_source.dart';
import 'package:carbon_zero/features/emission/data/models/emission_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// class to communicate with the data source
class EmissionRepository implements IEmissionDataSource {
  /// EmissionRepository constructor
  EmissionRepository({required EmissionDataSource dataSource})
      : _dataSource = dataSource;

  final EmissionDataSource _dataSource;
  @override
  Future<void> recordEmission(
    EmissionType type,
    String userId,
    double totalEmission,
  ) async {
    await _dataSource.recordEmission(type, userId, totalEmission);
  }
}

/// emission repository provider
final emissionRecordingRepositoryProvider = Provider<EmissionRepository>((ref) {
  final dataSource = ref.read(emissionDatSourceProvider);
  return EmissionRepository(dataSource: dataSource);
});
