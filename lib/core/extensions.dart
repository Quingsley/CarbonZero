import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/chat/data/model/chat_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/emission/data/models/emission_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// [AppThemeExtension] extension will get the current textTheme of the app
extension AppThemeExtension on BuildContext {
  /// gets  the current [TextTheme] form the given context
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// gets the app current [ColorScheme]
  ColorScheme get colors => Theme.of(this).colorScheme;
}

/// will be used to compare two dates and check if they are the same
/// exclusive of the time
extension DateComparison on DateTime {
  /// compares two dates and checks if they are the same
  bool dateComparison(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

/// [CollectionReference] extension will add a community model converter
/// to the collection reference
extension ModelConverter on CollectionReference {
  /// adds a [CommunityModel] converter to the collection reference
  CollectionReference<CommunityModel> withCommunityModelConverter() {
    return withConverter<CommunityModel>(
      fromFirestore: (snapshot, _) => CommunityModel.fromJson(snapshot.data()!),
      toFirestore: (community, _) => community.toJson(),
    );
  }

  /// [CollectionReference] extension will add a [UserModel] converter
  CollectionReference<UserModel> withUserModelConverter() {
    return withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }

  /// [CollectionReference] extension will add a [ChatModel] converter
  CollectionReference<ChatModel> withChatModelConverter() {
    return withConverter(
      fromFirestore: (snapshot, _) => ChatModel.fromJson(snapshot.data()!),
      toFirestore: (chat, _) => chat.toJson(),
    );
  }

  /// adds the [ActivityModel] converter to the collection reference
  CollectionReference<ActivityModel> withActivityModelConverter() {
    return withConverter(
      fromFirestore: (snapshot, _) => ActivityModel.fromJson(snapshot.data()!),
      toFirestore: (activity, _) => activity.toJson(),
    );
  }

  /// adds the [ActivityRecordingModel] converter to the collection reference
  CollectionReference<ActivityRecordingModel>
      withActivityRecordingModelConverter() {
    return withConverter(
      fromFirestore: (snapshot, _) =>
          ActivityRecordingModel.fromJson(snapshot.data()!),
      toFirestore: (activityRecording, _) => activityRecording.toJson(),
    );
  }

  /// adds the [EmissionModel] converter to the collection reference
  CollectionReference<EmissionModel> withEmissionModelConverter() {
    return withConverter(
      fromFirestore: (snapshot, _) => EmissionModel.fromJson(snapshot.data()!),
      toFirestore: (emission, _) => emission.toJson(),
    );
  }
}
