import 'package:equatable/equatable.dart';

/// Community model of the application
class CommunityModel extends Equatable {
  /// Community model of the application
  const CommunityModel({
    required this.name,
    required this.description,
    required this.posterId,
    required this.tags,
    required this.adminId,
    this.rewardId,
    this.id,
    this.members = 0,
    this.userIds = const [],
    this.activityIds = const [],
  });

  /// converts a json map to a [CommunityModel]
  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'name': final String name,
          'description': final String description,
          'posterId': final String posterId,
          'id': final String? id,
          'members': final int members,
          'tags': final List<dynamic> tags,
          'userIds': final List<dynamic> userIds,
          'activityIds': final List<dynamic> activityIds,
          'adminId': final String adminId,
          'rewardId': final String? rewardId,
        }) {
      return CommunityModel(
        name: name,
        description: description,
        posterId: posterId,
        tags: List.from(tags),
        adminId: adminId,
        id: id,
        members: members,
        userIds: List.from(userIds),
        activityIds: List.from(activityIds),
        rewardId: rewardId,
      );
    } else {
      throw FormatException('Invalid json $json');
    }
  }

  /// name of the community
  final String name;

  /// description of the community
  final String description;

  /// image of the community
  final String posterId;

  /// community id
  final String? id;

  /// number of members in the community
  final int members;

  /// tags of the community
  final List<String> tags;

  /// user ids in the community
  final List<String> userIds;

  /// activity ids in the community
  final List<String> activityIds;

  /// admin id of the community
  final String adminId;

  /// reward id of the community
  final String? rewardId;

  /// returns a community model from a json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'posterId': posterId,
      'id': id,
      'members': members,
      'tags': tags,
      'userIds': userIds,
      'activityIds': activityIds,
      'adminId': adminId,
      'rewardId': rewardId,
    };
  }

  /// returns a copied version of [CommunityModel] with
  /// the specified parameters replacing the old properties
  CommunityModel copyWith({
    String? name,
    String? description,
    String? posterId,
    String? id,
    int? members,
    List<String>? tags,
    List<String>? userIds,
    List<String>? activityIds,
    String? adminId,
    String? rewardId,
  }) {
    return CommunityModel(
      name: name ?? this.name,
      description: description ?? this.description,
      posterId: posterId ?? this.posterId,
      id: id ?? this.id,
      members: members ?? this.members,
      tags: tags ?? this.tags,
      userIds: userIds ?? this.userIds,
      activityIds: activityIds ?? this.activityIds,
      adminId: adminId ?? this.adminId,
      rewardId: rewardId ?? this.rewardId,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        posterId,
        id,
        members,
        tags,
        userIds,
        activityIds,
        adminId,
        rewardId,
      ];

  @override
  bool? get stringify => true;
}
