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
    this.carbonFootPrintNow = 0,
    this.initialCarbonFootPrint = 0,
    this.pushTokens = const [],
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
          'carbonFootPrintNow': final double carbonFootPrintNow,
          'initialCarbonFootPrint': final double initialCarbonFootPrint,
          'pushTokens': final List<dynamic> pushTokens,
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
        carbonFootPrintNow: carbonFootPrintNow,
        initialCarbonFootPrint: initialCarbonFootPrint,
        pushTokens: List.from(pushTokens),
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

  /// current carbon footprint of the user
  final double carbonFootPrintNow;

  /// initial carbon footprint of the user for the
  /// first time the user signed up for the past 12 months
  final double initialCarbonFootPrint;

  /// will have the push tokens of the user
  final List<String> pushTokens;

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
    double? carbonFootPrintNow,
    double? initialCarbonFootPrint,
    List<String>? pushTokens,
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
      carbonFootPrintNow: carbonFootPrintNow ?? this.carbonFootPrintNow,
      initialCarbonFootPrint:
          initialCarbonFootPrint ?? this.initialCarbonFootPrint,
      pushTokens: pushTokens ?? this.pushTokens,
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
      'carbonFootPrintNow': carbonFootPrintNow,
      'initialCarbonFootPrint': initialCarbonFootPrint,
      'pushTokens': pushTokens,
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
        carbonFootPrintNow,
        initialCarbonFootPrint,
        pushTokens,
      ];

  @override
  bool? get stringify => true;
}
