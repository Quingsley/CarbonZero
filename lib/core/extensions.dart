import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// [AppThemeExtension] extension will get the current textTheme of the app
extension AppThemeExtension on BuildContext {
  /// gets  the current [TextTheme] form the given context
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// gets the app current [ColorScheme]
  ColorScheme get colors => Theme.of(this).colorScheme;
}

/// [CollectionReference] extension will add a community model converter
/// to the collection reference
extension ModelConverter on CollectionReference {
  /// adds a community model converter to the collection reference
  CollectionReference<CommunityModel> withCommunityModelConverter() {
    return withConverter<CommunityModel>(
      fromFirestore: (snapshot, _) => CommunityModel.fromJson(snapshot.data()!),
      toFirestore: (community, _) => community.toJson(),
    );
  }

  /// [CollectionReference] extension will add a user model converter
  CollectionReference<UserModel> withUserModelConverter() {
    return withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }
}
