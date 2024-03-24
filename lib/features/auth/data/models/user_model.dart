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
    this.totalCarbonPoints = 0,
    this.userId,
    this.photoId,
    this.welcomeMessage,
    this.footPrintGoal = 0,
    this.carbonFootPrintNow = 0,
    this.initialCarbonFootPrint = 0,
    this.communityGoal = 0,
    this.pushTokens = const [],
    this.monthlyFootPrintData = const {},
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
          'totalCarbonPoints': final int totalCarbonPoints,
          'activityIds': final List<dynamic> activityIds,
          'communityIds': final List<dynamic> communityIds,
          'carbonFootPrintNow': final double carbonFootPrintNow,
          'initialCarbonFootPrint': final double initialCarbonFootPrint,
          'pushTokens': final List<dynamic> pushTokens,
          'monthlyFootPrintData': final Map<String, dynamic>
              monthlyFootPrintData,
          'footPrintGoal': final double footPrintGoal,
          'welcomeMessage': final String? welcomeMessage,
          'communityGoal': final double communityGoal,
        }) {
      return UserModel(
        userId: userId,
        fName: fName,
        lName: lName,
        email: email,
        totalCarbonPoints: totalCarbonPoints,
        photoId: photoId,
        activityIds: List.from(activityIds),
        communityIds: List.from(communityIds),
        carbonFootPrintNow: carbonFootPrintNow,
        initialCarbonFootPrint: initialCarbonFootPrint,
        pushTokens: List.from(pushTokens),
        footPrintGoal: footPrintGoal,
        communityGoal: communityGoal,
        welcomeMessage: welcomeMessage,
        monthlyFootPrintData: monthlyFootPrintData.map(
          (key, value) => MapEntry(key, value as double),
        ),
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

  /// total carbon points earned
  final int totalCarbonPoints;

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

  ///monthlyFootPrintData
  final Map<String, double> monthlyFootPrintData;

  /// footPrintGoal of the user
  final double footPrintGoal;

  /// communityGoal of the user
  final double communityGoal;

  /// welcome message for the user
  final String? welcomeMessage;

  /// copy with method to create a new instance of [UserModel]
  /// with updated values
  UserModel copyWith({
    String? userId,
    String? fName,
    String? lName,
    String? email,
    int? totalCarbonPoints,
    List<String>? activityIds,
    List<String>? communityIds,
    String? photoId,
    double? carbonFootPrintNow,
    double? initialCarbonFootPrint,
    List<String>? pushTokens,
    Map<String, double>? monthlyFootPrintData,
    double? footPrintGoal,
    String? welcomeMessage,
    double? communityGoal,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      email: email ?? this.email,
      totalCarbonPoints: totalCarbonPoints ?? this.totalCarbonPoints,
      activityIds: activityIds ?? this.activityIds,
      communityIds: communityIds ?? this.communityIds,
      photoId: photoId ?? this.photoId,
      carbonFootPrintNow: carbonFootPrintNow ?? this.carbonFootPrintNow,
      initialCarbonFootPrint:
          initialCarbonFootPrint ?? this.initialCarbonFootPrint,
      pushTokens: pushTokens ?? this.pushTokens,
      monthlyFootPrintData: monthlyFootPrintData ?? this.monthlyFootPrintData,
      footPrintGoal: footPrintGoal ?? this.footPrintGoal,
      communityGoal: communityGoal ?? this.communityGoal,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
    );
  }

  /// convert [UserModel] to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'fName': fName,
      'lName': lName,
      'email': email,
      'totalCarbonPoints': totalCarbonPoints,
      'activityIds': activityIds,
      'communityIds': communityIds,
      'photoId': photoId,
      'carbonFootPrintNow': carbonFootPrintNow,
      'initialCarbonFootPrint': initialCarbonFootPrint,
      'pushTokens': pushTokens,
      'monthlyFootPrintData': monthlyFootPrintData,
      'footPrintGoal': footPrintGoal,
      'communityGoal': communityGoal,
      'welcomeMessage': welcomeMessage,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        fName,
        lName,
        email,
        totalCarbonPoints,
        activityIds,
        communityIds,
        photoId,
        carbonFootPrintNow,
        initialCarbonFootPrint,
        pushTokens,
        monthlyFootPrintData,
        communityGoal,
        footPrintGoal,
        welcomeMessage,
      ];

  @override
  bool? get stringify => true;
}
