import 'package:equatable/equatable.dart';

/// ActivityRecordingModel class
class ActivityRecordingModel extends Equatable {
  /// ActivityRecordingModel class constructor
  const ActivityRecordingModel({
    required this.activityId,
    required this.parentId,
    required this.date,
    required this.description,
    required this.imageUrl,
    this.id,
  });

  /// converts the json to ActivityRecordingModel type
  factory ActivityRecordingModel.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': final String? id,
          'activityId': final String activityId,
          'parentId': final String parentId,
          'date': final String date,
          'description': final String description,
          'imageUrl': final String imageUrl,
        }) {
      return ActivityRecordingModel(
        id: id,
        activityId: activityId,
        parentId: parentId,
        date: date,
        description: description,
        imageUrl: imageUrl,
      );
    } else {
      throw FormatException('Invalid JSON format $json');
    }
  }

  /// converts the activityRecording to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'parentId': parentId,
      'date': date,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// id of the activity recording
  final String? id;

  /// id of the activity
  final String activityId;

  /// id of the user/ community
  final String parentId;

  /// date of the activity recording
  final String date;

  /// description of the activity recording

  final String description;

  /// image url of the activity recording
  final String imageUrl;

  @override
  List<Object?> get props =>
      [id, activityId, parentId, date, description, imageUrl];

  /// copyWith method for ActivityRecordingModel
  ActivityRecordingModel copyWith({
    String? id,
    String? activityId,
    String? parentId,
    String? date,
    String? description,
    String? imageUrl,
  }) {
    return ActivityRecordingModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      activityId: activityId ?? this.activityId,
      parentId: parentId ?? this.parentId,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
