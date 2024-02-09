import 'package:equatable/equatable.dart';

/// chat model of a user
class ChatModel extends Equatable {
  /// chat model of a user
  const ChatModel({
    required this.message,
    required this.senderId,
    required this.communityId,
    required this.sentAt,
    required this.userName,
    this.chatId,
    this.media,
    this.imageUrl,
  });

  /// takes a [json] and coverts it to a [ChatModel]
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'message': final String message,
          'sentAt': final String sentAt,
          'media': final String? media,
          'communityId': final String communityId,
          'chatId': final String? chatId,
          'senderId': final String senderId,
          'imageUrl': final String? imageUrl,
          'userName': final String userName,
        }) {
      return ChatModel(
        message: message,
        senderId: senderId,
        communityId: communityId,
        sentAt: sentAt,
        media: media,
        chatId: chatId,
        imageUrl: imageUrl,
        userName: userName,
      );
    } else {
      throw FormatException('invalid json data $json');
    }
  }

  /// chat message
  final String message;

  /// id of the user sending the message
  final String senderId;

  /// id of the chat
  final String? chatId;

  /// recipient of the message
  final String communityId;

  /// time message was sent
  final String sentAt;

  /// media associated with the chat
  final String? media;

  /// name of the sender
  final String userName;

  /// avatar of the sender
  final String? imageUrl;

  /// converts [ChatModel] instance to a map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sentAt': sentAt,
      'media': media,
      'communityId': communityId,
      'chatId': chatId,
      'senderId': senderId,
      'imageUrl': imageUrl,
      'userName': userName,
    };
  }

  /// copy with method to create a new instance of [ChatModel]
  /// with updated values
  ChatModel copyWith({
    String? message,
    String? chatId,
    String? communityId,
    String? media,
    String? senderId,
    String? sentAt,
    String? imageUrl,
    String? userName,
  }) {
    return ChatModel(
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      communityId: communityId ?? this.communityId,
      sentAt: sentAt ?? this.sentAt,
      chatId: chatId ?? this.chatId,
      media: media ?? this.media,
      userName: userName ?? this.userName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        message,
        senderId,
        chatId,
        communityId,
        sentAt,
      ];

  @override
  bool? get stringify => true;
}
