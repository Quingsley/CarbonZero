//Show options to get image from camera or gallery
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

/// will present user options to pick image from either the
/// gallery or the camera
Future<ImageSource?> showOptions(BuildContext context) async {
  return showCupertinoModalPopup<ImageSource>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: const Text('Gallery'),
          onPressed: () {
            // close the options modal
            Navigator.of(context).pop(ImageSource.gallery);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text('Camera'),
          onPressed: () {
            // close the options modal
            Navigator.of(context).pop(ImageSource.camera);
          },
        ),
      ],
    ),
  );
}
