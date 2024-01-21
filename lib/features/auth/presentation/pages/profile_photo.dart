import 'dart:io';

import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// [ProfilePhoto] screen that allows user to set profile photo
class ProfilePhoto extends StatefulWidget {
  ///constructor call
  const ProfilePhoto({super.key});

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  //TODO: refactor this into its own service
  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  String? imagePath;
// Pick an image.

  Future<void> pickImage() async {
    // will need to show
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = pickedImage?.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a photo',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Make it easy to recognize you',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
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
                                fit: BoxFit.contain,
                                image: FileImage(
                                  File(
                                    imagePath!,
                                  ),
                                ),
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
                    child: IconButton.filled(
                      onPressed: pickImage,
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Continue',
              onPressed: imagePath != null
                  ? () {
                      context.go('/auth/profile-complete');
                    }
                  : null,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
