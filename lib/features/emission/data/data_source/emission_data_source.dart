import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/emission/data/models/emission_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// contains methods related to updating user emissions in the db
abstract class IEmissionDataSource {
  /// will record the emission and update the user monthly emissions in the db
  Future<void> recordEmission(
    EmissionType type,
    String userId,
    double totalEmission,
  );
}

/// EmissionDataSource class
class EmissionDataSource implements IEmissionDataSource {
  /// EmissionDataSource constructor
  EmissionDataSource({required FirebaseFirestore db}) : _db = db;

  /// instance of firestore
  final FirebaseFirestore _db;
  @override
  Future<void> recordEmission(
    EmissionType type,
    String userId,
    double totalEmission,
  ) async {
    try {
      final emission = EmissionModel(
        date: DateTime.now().toIso8601String(),
        co2emitted: totalEmission,
        pointsEarned: 10,
        userId: userId,
        type: type,
      );
      final docRef = await _db
          .collection('emissions')
          .withEmissionModelConverter()
          .add(emission);

      await docRef.update({
        'id': docRef.id,
      });
      final user = await _db
          .collection('users')
          .withUserModelConverter()
          .doc(userId)
          .get();
      await user.reference.update({
        'carbonFootPrintNow': FieldValue.increment(totalEmission),
      });
    } on FirebaseException catch (e) {
      throw Failure(
        message: e.message ?? 'An error occurred while recording the emission',
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// emission data source
final emissionDatSourceProvider = Provider<EmissionDataSource>((ref) {
  final db = ref.read(dbProvider);
  if (db == null) throw AssertionError('User not logged in, Cannot access db');
  return EmissionDataSource(db: db);
});
