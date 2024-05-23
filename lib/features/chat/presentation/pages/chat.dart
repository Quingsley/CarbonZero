// import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/chat/data/model/chat_model.dart';
import 'package:carbon_zero/features/chat/presentation/view_models/chat_view_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
// import 'package:carbon_zero/services/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// community inbox where users can chat
class CommunityInbox extends ConsumerStatefulWidget {
  /// community inbox where users can chat
  const CommunityInbox({required this.communityModel, super.key});

  /// the community model the user is chatting with
  final CommunityModel communityModel;

  @override
  ConsumerState<CommunityInbox> createState() => _CommunityInboxState();
}

class _CommunityInboxState extends ConsumerState<CommunityInbox> {
  late final UserModel? user; // logged in user
  @override
  void initState() {
    super.initState();
    user = ref.read(userStreamProvider).value;
  }

  @override
  Widget build(BuildContext context) {
    final chatUser = types.User(id: user!.userId!);
    final chatViewModel = ref.watch(chatViewModelProvider);
    final isLoading = chatViewModel is AsyncLoading;
    final messages = ref.watch(chatStreamProvider(widget.communityModel.id!));

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.communityModel.posterId),
            ),
          ],
        ),
        title: Text(widget.communityModel.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push(
                '/community/inbox/members',
                extra: widget.communityModel.userIds,
              );
            },
            tooltip: 'Members',
            icon: const Icon(Icons.people_alt_outlined),
          ),
          IconButton(
            color: Colors.amber,
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              context.push(
                '/community/inbox/challenges',
                extra: widget.communityModel.id,
              );
            },
          ),
        ],
      ),
      body: Chat(
        theme: DefaultChatTheme(
          backgroundColor: context.colors.surface,
          primaryColor: context.colors.primary,
          secondaryColor: context.colors.secondary,
          errorColor: context.colors.error,
          inputContainerDecoration: BoxDecoration(
            color: context.colors.surface,
          ),
          inputTextColor: context.colors.onSurface,
          inputTextDecoration: const InputDecoration(
            hintText: 'Type here..',
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.all(10),
          ),
        ),
        showUserAvatars: true,
        showUserNames: true,
        emptyState: isLoading ? const Text('Loading messages...') : null,
        messages: messages.when(
          data: (data) {
            data.sort(
              (a, b) {
                final time1 = DateTime.parse(a.sentAt);
                final time2 = DateTime.parse(b.sentAt);
                // descending order look into firestore indexes
                // tried them but not working
                return time2.compareTo(time1);
              },
            );
            return data
                .map(
                  (chat) => types.TextMessage(
                    id: chat.chatId ?? DateTime.now().toString(),
                    author: types.User(
                      id: chat.senderId,
                      firstName: chat.userName,
                      imageUrl: chat.imageUrl,
                      role: widget.communityModel.adminId == chat.senderId
                          ? types.Role.admin
                          : types.Role.user,
                    ),
                    text: chat.message,
                    roomId: widget.communityModel.id,
                    createdAt:
                        DateTime.parse(chat.sentAt).millisecondsSinceEpoch,
                  ),
                )
                .toList();
          },
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Error fetching images'),
                backgroundColor: context.colors.error,
              ),
            );

            return [];
          },
          loading: () {
            return [];
          },
        ),
        onSendPressed: !isLoading
            ? (value) async {
                final chat = ChatModel(
                  message: value.text,
                  senderId: user!.userId!,
                  userName: user!.fName,
                  imageUrl: user!.photoId,
                  communityId: widget.communityModel.id!,
                  sentAt: DateTime.now().toIso8601String(),
                );
                await ref.read(chatViewModelProvider.notifier).sendChat(chat);
              }
            : (val) {},
        user: chatUser,
      ),
    );
  }
}

// figure out usage
Future<types.ImageMessage?> _handleImageSelection(types.User user) async {
  final result = await ImagePicker().pickImage(
    imageQuality: 70,
    maxWidth: 1440,
    source: ImageSource.gallery,
  );

  if (result != null) {
    final bytes = await result.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final message = types.ImageMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      height: image.height.toDouble(),
      id: DateTime.now().toString(),
      name: result.name,
      size: bytes.length,
      uri: result.path,
      width: image.width.toDouble(),
    );

    return message;
  }
  return null;
}

//TODO:
// work on statuses
// work on image uploads (for now) audio later
