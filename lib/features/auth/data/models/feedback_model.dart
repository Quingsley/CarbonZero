import 'package:equatable/equatable.dart';

/// [FeedBackModel] class is a model class for feedback
class FeedBackModel extends Equatable {
  /// constructor
  const FeedBackModel({required this.message, required this.userId});

  /// feedback message
  final String message;

  /// user id
  final String userId;

  /// converts the model to a map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
    };
  }

  @override
  List<Object?> get props => [message, userId];
  @override
  bool? get stringify => true;
}
