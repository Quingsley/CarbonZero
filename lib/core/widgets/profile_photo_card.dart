import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/utils/show_camera_options.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/services/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will show the profile photo of the user with the
/// ability to edit it
class ProfilePhotoCard extends ConsumerStatefulWidget {
  /// constructor call
  const ProfilePhotoCard({super.key});

  @override
  ConsumerState<ProfilePhotoCard> createState() => _ProfilePhotoCardState();
}

class _ProfilePhotoCardState extends ConsumerState<ProfilePhotoCard> {
  String? imagePath;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authInstanceProvider);
    imagePath = user.currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    final imageService = ref.watch(imageServiceProvider);
    final isLoading = imageService is AsyncLoading;
    ref
      ..listen(imageServiceProvider, (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(error is Failure ? error.message : error.toString()),
              ),
            );
          },
          data: (data) {
            imagePath = data[ImageType.profile]; // check if this is needed
            final auth = ref.read(authStateChangesProvider);
            if (auth.value != null && imagePath != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('photo uploaded successfully'),
                ),
              );
            }
          },
        );
      })
      ..listen(authStateChangesProvider, (previous, next) {
        next.whenData((value) {
          imagePath = value?.photoURL;
        });
      });
    return Align(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            child: imagePath != null
                ? Container(
                    // height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(1000),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) => const SizedBox(),
                        image: NetworkImage(imagePath ?? ''),
                      ),
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 120,
                  ),
          ),
          Positioned(
            bottom: 10,
            left: 140,
            child: isLoading
                ? const CircularProgressIndicator()
                : IconButton.filled(
                    onPressed: !isLoading
                        ? () async {
                            final source = await showOptions(context);
                            if (source != null) {
                              await ref
                                  .read(imageServiceProvider.notifier)
                                  .uploadPhoto(ImageType.profile, source);
                              if (imagePath != null) {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .uploadProfileImage(imagePath!);
                              }
                            }
                          }
                        : null,
                    icon: const Icon(Icons.add_a_photo_outlined),
                  ),
          ),
        ],
      ),
    );
  }
}
