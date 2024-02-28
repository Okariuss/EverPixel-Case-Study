import 'dart:io';

import 'package:flutter/material.dart';

import '../edit/edit_image_page.dart';
import 'home_repo.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository repo = HomeRepository();

  List<File> get imageList => repo.imageList;
  List<String> get galleryHeaders => repo.galleryHeaders;
  String get selectedHeader => repo.selectedHeader;
  int get selectedIndex => repo.selectedIndex;

  void selectChip(int index) {
    repo.selectedIndex = index;
    notifyListeners();
  }

  void clearSelection() {
    repo.selectedIndex = -1;
    notifyListeners();
  }

  Future<void> loadGalleryHeaders() async {
    await repo.loadGalleryHeaders();
    notifyListeners();
  }

  Future<void> loadImages(String header) async {
    await repo.loadImages(header);
    notifyListeners();
  }

  Future<void> takePhoto(BuildContext context) async {
    var path = await repo.takePhoto();
    await loadGalleryHeaders();
    await loadImages(selectedHeader);
    if (path != null) {
      navigateToEditPageWithImage(context, path);
    }
    notifyListeners();
  }

  Future<void> selectImage(BuildContext context) async {
    var path = await repo.selectImage();
    if (path != null) {
      navigateToEditPageWithImage(context, path);
    }
  }

  Future<void> navigateToEditPageWithImage(
      BuildContext context, String path) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditImagePage(imagePath: path),
      ),
    );
  }

  void onTapHeaderChip(int index) {
    final bool isSelected = selectedIndex == index;
    if (isSelected) {
      clearSelection();
    } else {
      selectChip(index);
      loadImages(galleryHeaders[index]);
    }
  }
}
