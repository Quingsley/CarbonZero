import 'package:equatable/equatable.dart';

/// EmissionModel class
class EmissionModel extends Equatable {
  /// EmissionModel constructor
  const EmissionModel({
    required this.date,
    required this.co2emitted,
    required this.pointsEarned,
    required this.userId,
    required this.type,
    this.id,
  });

  /// fromJson method to convert the json to EmissionModel
  factory EmissionModel.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': final String? id,
          'date': final String date,
          'co2emitted': final double co2emitted,
          'pointsEarned': final int pointsEarned,
          'userId': final String userId,
          'type': final String emissionType,
        }) {
      return EmissionModel(
        id: id,
        date: date,
        co2emitted: co2emitted,
        pointsEarned: pointsEarned,
        userId: userId,
        type: EmissionType.values.firstWhere(
          (type) => type.name == emissionType,
        ),
      );
    } else {
      throw FormatException('Invalid JSON format $json');
    }
  }

  /// toJson method to convert the EmissionModel to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'co2emitted': co2emitted,
      'pointsEarned': pointsEarned,
      'userId': userId,
      'type': type.name,
    };
  }

  /// copyWith method to copy the EmissionModel
  EmissionModel copyWith({
    String? id,
    String? date,
    EmissionType? type,
    double? co2emitted,
    int? pointsEarned,
    String? userId,
  }) {
    return EmissionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      co2emitted: co2emitted ?? this.co2emitted,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      userId: userId ?? this.userId,
      type: type ?? this.type,
    );
  }

  /// id of the emission
  final String? id;

  /// day the emission was made
  final String date;

  /// co2 emitted
  final double co2emitted;

  /// points earned
  final int pointsEarned;

  /// user id
  final String userId;

  /// emission type
  final EmissionType type;

  @override
  List<Object?> get props => [
        id,
        date,
        co2emitted,
        pointsEarned,
        userId,
        type,
      ];
}

/// EmissionType enum
enum EmissionType {
  /// food type
  food,

  /// transport type
  transport,
}
