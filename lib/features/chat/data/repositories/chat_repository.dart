import 'package:carbon_zero/features/chat/data/model/chat_model.dart';
import 'package:carbon_zero/features/chat/data/remote_data_source/chat_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// reads the data returned by the [ChatDataSource] methods
class ChatRepository extends IChat {
  /// reads the data returned by the [ChatDataSource] methods
  ChatRepository({required ChatDataSource dataSource})
      : _dataSource = dataSource;

  final ChatDataSource _dataSource;
  @override
  Future<void> addChat(ChatModel chat) async {
    return _dataSource.addChat(chat);
  }

  @override
  Stream<List<ChatModel>> getMessages(String communityId) {
    return _dataSource.getMessages(communityId);
  }
}

/// provides the chat repository to the chat VM
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dataSource = ref.read(chatDataSourceProvider);
  return ChatRepository(dataSource: dataSource);
});
