import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/chat/data/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// abstract class containing methods share by the data source
/// and the repository
abstract class IChat {
  /// gets a list of messages of a particular community
  Stream<List<ChatModel>> getMessages(String communityId);

  /// adds a new chat to the chat collection
  Future<void> addChat(ChatModel chat);
}

/// chat data source
class ChatDataSource extends IChat {
  /// chat data source
  ChatDataSource({required FirebaseFirestore db}) : _db = db;

  final FirebaseFirestore _db;
  @override
  Future<void> addChat(ChatModel chat) async {
    try {
      final reference =
          await _db.collection('chats').withChatModelConverter().add(chat);
      await _db.collection('chats').doc(reference.id).update(
        {'chatId': reference.id},
      );
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ChatModel>> getMessages(String communityId) {
    try {
      final snapshot = _db
          .collection('chats')
          .withChatModelConverter()
          .where('communityId', isEqualTo: communityId)
          .snapshots();
      return snapshot
          .map((event) => event.docs.map((doc) => doc.data()).toList());
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }
}

/// provides the data source for the chat
final chatDataSourceProvider = Provider<ChatDataSource>((ref) {
  final db = ref.read(dbProvider);
  if (db == null) throw AssertionError('User is not logged in to access chat');
  return ChatDataSource(db: db);
});
