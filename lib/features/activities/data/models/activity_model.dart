import 'package:carbon_zero/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

/// ActivityModel class
class ActivityModel extends Equatable {
  /// ActivityModel class constructor
  const ActivityModel({
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.description,
    required this.type,
    required this.parentId,
    required this.icon,
    required this.color,
    required this.reminderTime,
    this.participants = const [],
    this.id,
    this.progress = 0,
    this.members = 1,
    this.cO2Emitted = 0,
    this.carbonPoints = 0,
  });

  /// converts the json to ActivityModel type
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': final String? id,
          'startDate': final String startDate,
          'endDate': final String endDate,
          'name': final String name,
          'description': final String description,
          'icon': final String icon,
          'type': final String type,
          'progress': final double progress,
          'members': final int members,
          'parentId': final String parentId,
          'cO2Emitted': final int cO2Emitted,
          'color': final int color,
          'reminderTime': final String reminderTime,
          'carbonPoints': final int carbonPoints,
          'participants': final List<dynamic> participants,
        }) {
      return ActivityModel(
        id: id,
        parentId: parentId,
        startDate: startDate,
        endDate: endDate,
        reminderTime: reminderTime,
        name: name,
        carbonPoints: carbonPoints,
        description: description,
        icon: icon,
        progress: progress,
        members: members,
        cO2Emitted: cO2Emitted,
        color: color,
        participants: List.from(participants),
        type: type == ActivityType.individual.name
            ? ActivityType.individual
            : ActivityType.community,
      );
    } else {
      throw FormatException('Invalid JSON format $json');
    }
  }

  /// converts the ActivityModel to json type
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.name,
      'progress': progress,
      'members': members,
      'parentId': parentId,
      'cO2Emitted': cO2Emitted,
      'color': color,
      'reminderTime': reminderTime,
      'carbonPoints': carbonPoints,
      'participants': participants,
    };
  }

  /// returns a copy of the ActivityModel
  ActivityModel copyWith({
    String? id,
    String? startDate,
    String? endDate,
    String? name,
    String? description,
    String? icon,
    ActivityType? type,
    double? progress,
    int? members,
    String? parentId,
    int? cO2Emitted,
    int? color,
    String? reminderTime,
    int? carbonPoints,
    List<String>? participants,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminderTime: reminderTime ?? this.reminderTime,
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      progress: progress ?? this.progress,
      members: members ?? this.members,
      cO2Emitted: cO2Emitted ?? this.cO2Emitted,
      carbonPoints: carbonPoints ?? this.carbonPoints,
      participants: participants ?? this.participants,
    );
  }

  /// id of the activity
  final String? id;

  /// start date of the activity
  final String startDate;

  /// end date of the activity
  final String endDate;

  /// name of the activity
  final String name;

  /// description of the activity
  final String description;

  /// image url of the activity
  final String icon;

  /// type of the activity
  final ActivityType type;

  /// progress of the activity
  final double progress;

  /// members of the activity by default 1
  final int members;

  /// will have the id of the user/ community who created the activity
  final String parentId;

  /// will hold the cumulative CO2e during the period of the activity
  final int cO2Emitted;

  /// color of the activity to show in chart
  final int color;

  /// time to remind user about activity
  final String reminderTime;

  /// carbon points earned
  final int carbonPoints;

  /// will contain user Ids who are participating in the activity for
  /// community activities
  final List<String> participants;

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        name,
        description,
        icon,
        type,
        parentId,
        members,
        progress,
        color,
        cO2Emitted,
        participants,
      ];

  @override
  bool? get stringify => true;
}
