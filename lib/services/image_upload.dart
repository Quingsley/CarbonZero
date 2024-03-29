import 'dart:async';
import 'dart:io';

import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// image upload service
class ImageUpload extends AsyncNotifier<Map<ImageType?, String?>> {
  @override
  FutureOr<Map<ImageType?, String?>> build() {
    return {};
  }

  /// instance of imagePicker
  final _picker = ImagePicker();

  /// used to pick an image
  Future<void> uploadPhoto(
    ImageType imageType, [
    ImageSource source = ImageSource.gallery,
  ]) async {
    try {
      final user = ref.watch(authStateChangesProvider).value;
      final storage = ref.read(storageProvider);

      XFile? pickedImage;
      final storageRef = storage.ref();
      UploadTask? uploadTask;

      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        pickedImage = await _picker.pickImage(source: source);

        if (pickedImage != null) {
          final extension = pickedImage?.path.split('.').last;

          final name = imageType == ImageType.profile
              ? '${user?.uid}.$extension'
              : imageType == ImageType.community
                  ? 'community-${user?.uid}-${DateTime.timestamp()}.$extension'
                  : 'activity-${user?.uid}-${DateTime.timestamp()}.$extension';

          final folder = imageType == ImageType.profile
              ? 'profile_images'
              : imageType == ImageType.community
                  ? 'community_images'
                  : 'activity_images';

          final profileRef = storageRef.child('$folder/$name');

          uploadTask = profileRef.putFile(
            File(pickedImage!.path).absolute,
            SettableMetadata(contentType: 'image/$extension'),
          );

          final snapshot = await uploadTask?.whenComplete(() {});

          final downloadUrl = await snapshot?.ref.getDownloadURL();
          return {imageType: downloadUrl};
        }
        return {};
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }
}

/// provides methods to be invoked by ui
final imageServiceProvider =
    AsyncNotifierProvider<ImageUpload, Map<ImageType?, String?>>(
  ImageUpload.new,
);
