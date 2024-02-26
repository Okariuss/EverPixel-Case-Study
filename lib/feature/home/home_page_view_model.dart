import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixvibe_clone/product/base/base_view_model.dart';

import '../edit/edit_image_page.dart';

class HomeViewModel extends BaseViewModel {
  Future<void> _getImageAndPush(
      BuildContext context, ImageSource source) async {
    setBusy(true);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditImagePage(imagePath: pickedFile.path),
        ),
      );
    }
    setBusy(false);
  }

  Future<void> takePhoto(BuildContext context) async {
    await _getImageAndPush(context, ImageSource.camera);
  }

  Future<void> selectImage(BuildContext context) async {
    await _getImageAndPush(context, ImageSource.gallery);
  }
}
