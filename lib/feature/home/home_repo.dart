import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class HomeRepository {
  List<File> imageList = [];
  List<String> galleryHeaders = [];
  late String selectedHeader;
  late List<AssetPathEntity> paths;
  int selectedIndex = -1;

  Future<void> loadGalleryHeaders() async {
    try {
      await Permission.photos.request();
      paths = await PhotoManager.getAssetPathList(type: RequestType.image);

      List<String> headers = paths.map((path) => path.name).toList();

      // Filter out headers with no images
      List<String> nonEmptyHeaders = [];
      for (String header in headers) {
        final AssetPathEntity? selectedHeader = await _findHeaderByName(header);
        if (selectedHeader != null) {
          final List<AssetEntity> assetList =
              await selectedHeader.getAssetListRange(
                  start: 0, end: 1); // Check if there's at least one image
          if (assetList.isNotEmpty) {
            nonEmptyHeaders.add(header);
          }
        }
      }
      selectedIndex = 0;
      selectedHeader = nonEmptyHeaders.first;
      galleryHeaders = nonEmptyHeaders;
    } catch (e) {
      print('Error loading gallery headers: $e');
    }
  }

  Future<void> loadImages(String header) async {
    try {
      final AssetPathEntity? selectedHeader = await _findHeaderByName(header);

      if (selectedHeader != null) {
        imageList.clear();
        final List<AssetEntity> assetList = await selectedHeader
            .getAssetListRange(start: 0, end: double.maxFinite.toInt());
        for (final entity in assetList) {
          final File? file = await entity.file;
          if (file != null) {
            imageList.add(file);
          }
        }
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<void> saveImageToGallery(Uint8List? imageBytes) async {
    if (imageBytes == null) return;

    try {
      var isPermissionGranted = await Permission.photos.request();
      if (isPermissionGranted.isDenied) {
        // Handle case where permission is not granted
        print("denied");
        return;
      }

      var timeStamp = DateTime.now().millisecondsSinceEpoch;

      final title = '${timeStamp}.jpg';

      final AssetEntity? savedImage =
          await PhotoManager.editor.saveImage(imageBytes, title: title);

      if (savedImage != null) {
        print('Image saved to gallery: ${savedImage.title}');
      } else {
        print('Failed to save image to gallery.');
      }
    } catch (e) {
      print('Error saving image to gallery: $e');
    }
  }

  Future<String?> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      await saveImageToGallery(imageBytes);
      return pickedFile.path;
    }
    return null;
  }

  Future<String?> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  Future<AssetPathEntity?> _findHeaderByName(String name) async {
    try {
      if (paths == null) {
        paths = await PhotoManager.getAssetPathList(type: RequestType.image);
      }
      return paths.firstWhere((path) => path.name == name);
    } catch (e) {
      print('Error finding header by name: $e');
      return null;
    }
  }
}
