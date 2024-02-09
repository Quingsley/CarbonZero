import 'dart:async';

import 'package:carbon_zero/features/chat/data/model/chat_model.dart';
import 'package:carbon_zero/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// responsible for the the uni-direction flow fo data
/// from the ui to the chat remote services
class ChatViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  /// used to send a chat message
  Future<void> sendChat(ChatModel chat) async {
    final repo = ref.read(chatRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.addChat(chat));
  }
}

/// provides the async value to the UI
final chatViewModelProvider =
    AsyncNotifierProvider<ChatViewModel, void>(ChatViewModel.new);

/// streams the chat for a given community
final chatStreamProvider =
    StreamProvider.family<List<ChatModel>, String>((ref, id) {
  final repo = ref.read(chatRepositoryProvider);
  return repo.getMessages(id);
});
