import 'package:equatable/equatable.dart';

/// user model
class UserModel extends Equatable {
  /// const constructor
  const UserModel({
    required this.fName,
    required this.lName,
    required this.email,
    required this.activityIds,
    required this.communityIds,
    this.rewardId,
    this.userId,
    this.photoId,
  });

  /// factory method to create a new instance of [UserModel] from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'userId': final String userId,
          'fName': final String fName,
          'lName': final String lName,
          'email': final String email,
          'photoId': final String? photoId,
          'rewardId': final String? rewardId,
          'activityIds': final List<dynamic> activityIds,
          'communityIds': final List<dynamic> communityIds,
        }) {
      return UserModel(
        userId: userId,
        fName: fName,
        lName: lName,
        email: email,
        rewardId: rewardId,
        photoId: photoId,
        activityIds: List.from(activityIds),
        communityIds: List.from(communityIds),
      );
    } else {
      throw const FormatException('Invalid user model');
    }
  }

  /// first name of user
  final String fName;

  /// last name of user
  final String lName;

  /// email of user
  final String email;

  /// user id
  final String? userId;

  /// reward id
  final String? rewardId;

  /// list of activity ids
  final List<String> activityIds;

  /// list of community ids
  final List<String> communityIds;

  /// photo id
  final String? photoId;

  /// copy with method to create a new instance of [UserModel]
  /// with updated values
  UserModel copyWith({
    String? userId,
    String? fName,
    String? lName,
    String? email,
    String? rewardId,
    List<String>? activityIds,
    List<String>? communityIds,
    String? photoId,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      email: email ?? this.email,
      rewardId: rewardId ?? this.rewardId,
      activityIds: activityIds ?? this.activityIds,
      communityIds: communityIds ?? this.communityIds,
      photoId: photoId ?? this.photoId,
    );
  }

  /// convert [UserModel] to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'fName': fName,
      'lName': lName,
      'email': email,
      'rewardId': rewardId,
      'activityIds': activityIds,
      'communityIds': communityIds,
      'photoId': photoId,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        fName,
        lName,
        email,
        rewardId,
        activityIds,
        communityIds,
        photoId,
      ];

  @override
  bool? get stringify => true;
}
