import 'dart:io';

import 'package:flutter/material.dart';

import '../../product/base/base_view_model.dart';
import '../edit/edit_page.dart';
import 'home_repo.dart';

class HomeViewModel extends BaseViewModel {
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
    try {
      setBusy(true);
      await repo.loadGalleryHeaders();
    } catch (e) {
      print('Error loading gallery headers: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> loadImages(String header) async {
    try {
      setBusy(true);
      await repo.loadImages(header);
    } catch (e) {
      print('Error loading images: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> takePhoto(BuildContext context) async {
    try {
      setBusy(true);
      var path = await repo.takePhoto();
      await loadGalleryHeaders();
      await loadImages(selectedHeader);
      if (path != null) {
        navigateToEditPageWithImage(context, path);
      }
    } catch (e) {
      print('Error taking photo: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> selectImage(BuildContext context) async {
    try {
      setBusy(true);
      var path = await repo.selectImage();
      if (path != null) {
        navigateToEditPageWithImage(context, path);
      }
    } catch (e) {
      print('Error selecting image: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> navigateToEditPageWithImage(
      BuildContext context, String path) async {
    try {
      setBusy(true);
      bool? shouldReload = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPage(
            imagePath: path,
          ),
        ),
      );

      if (shouldReload == true) {
        await loadGalleryHeaders();
        await loadImages(selectedHeader);
      }
    } catch (e) {
      print('Error navigating to edit page: $e');
    } finally {
      setBusy(false);
    }
  }

  void onTapHeaderChip(int index) {
    try {
      setBusy(true);
      final bool isSelected = selectedIndex == index;
      if (isSelected) {
        clearSelection();
      } else {
        selectChip(index);
        loadImages(galleryHeaders[index]);
      }
    } catch (e) {
      print('Error handling tap header chip: $e');
    } finally {
      setBusy(false);
    }
  }
}
