import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/services/image_upload.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Add image container will be used in forms that require image upload
class AddImageContainer extends ConsumerWidget {
  /// constructor
  const AddImageContainer({
    required this.imageType,
    required this.imageController,
    required this.containerLabel,
    this.showError = false,
    super.key,
  });

  /// controller for the image
  final TextEditingController imageController;

  /// label to be used for the container
  final String containerLabel;

  /// image type
  final ImageType imageType;

  /// will highlight the container if the image is not uploaded
  final bool showError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.watch(imageServiceProvider);
    final isLoading = imageService is AsyncLoading;
    ref.listen(imageServiceProvider, (previous, next) {
      next.whenOrNull(
        data: (url) {
          imageController.text = url!;
        },
      );
    });
    return Container(
      height: 200,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        // color: context.colors.primary,
        gradient: LinearGradient(
          colors: [
            context.colors.primary.withOpacity(0.62),
            context.colors.primary.withOpacity(0.31),
          ],
        ),
        image: imageController.text.isNotEmpty
            ? DecorationImage(
                image: FirebaseImageProvider(
                  FirebaseUrl(imageController.text),
                ),
                fit: BoxFit.cover,
                opacity: .5,
              )
            : null,
        border: Border.all(
          color: showError ? context.colors.error : context.colors.primary,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              color:
                  showError ? context.colors.error : context.colors.onPrimary,
              onPressed: !isLoading
                  ? () async {
                      await ref
                          .read(imageServiceProvider.notifier)
                          .uploadPhoto(imageType);
                    }
                  : null,
              icon: const Icon(Icons.add_a_photo),
            ),
          Text(
            containerLabel,
            style: TextStyle(
              color:
                  showError ? context.colors.error : context.colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
