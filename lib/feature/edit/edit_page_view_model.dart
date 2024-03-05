import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pixvibe_clone/product/base/base_view_model.dart';

enum FilterType { grayscale, sepia, sketch, pixelate, monochrome }

class FilterIsolateData {
  final SendPort sendPort;
  final img.Image image;
  final FilterType filter;

  FilterIsolateData({
    required this.sendPort,
    required this.image,
    required this.filter,
  });
}

class EditViewModel extends BaseViewModel {
  late final String imagePath;
  Uint8List? imageBytes;
  img.Image? originalImage;
  final List<Uint8List> filterPreviews = [];
  bool showPreview = false, isLoadingPreview = true;

  final List<Uint8List> editHistory = [];
  int currentEditIndex = -1;

  bool get canUndo => currentEditIndex > 0;
  bool get canRedo => currentEditIndex < editHistory.length - 1;

  EditViewModel(this.imagePath) {
    _loadImage();
  }

  void _loadImage() async {
    isLoadingPreview = true;
    notifyListeners();

    imageBytes = await File(imagePath).readAsBytes();
    originalImage = img.decodeImage(imageBytes!);

    if (originalImage != null) {
      editHistory.add(Uint8List.fromList(img.encodeJpg(originalImage!)));
      currentEditIndex = 0;
    }

    isLoadingPreview = false;

    await _generateFilterPreviews();

    notifyListeners();
  }

  Future<void> _generateFilterPreviews() async {
    filterPreviews.clear();
    var futures = FilterType.values.map(_createFilterPreview).toList();
    filterPreviews.addAll(await Future.wait(futures));
  }

  Future<Uint8List> _createFilterPreview(FilterType filter) async {
    var receivePort = ReceivePort();
    await Isolate.spawn(
        _applyFilterInIsolate,
        FilterIsolateData(
          sendPort: receivePort.sendPort,
          image: originalImage!,
          filter: filter,
        ));
    return await receivePort.first as Uint8List;
  }

  static void _applyFilterInIsolate(FilterIsolateData data) {
    var filteredImage = _applyFilter(data.image, data.filter);
    var encodedImage = Uint8List.fromList(img.encodeJpg(filteredImage));
    data.sendPort.send(encodedImage);
  }

  static img.Image _applyFilter(img.Image image, FilterType filter) {
    switch (filter) {
      case FilterType.grayscale:
        return img.grayscale(image);
      case FilterType.sepia:
        return img.sepia(image);
      case FilterType.sketch:
        return img.sketch(image);
      case FilterType.pixelate:
        return img.pixelate(image, size: 20);
      case FilterType.monochrome:
        return img.monochrome(image);
      default:
        return image;
    }
  }

  void toggleOptions() {
    showPreview = !showPreview;
    notifyListeners();
  }

  Future<void> setActiveFilter(int index) async {
    if (index < filterPreviews.length && originalImage != null) {
      imageBytes = await _applySelectedFilter(index);
      notifyListeners();
    }
  }

  Future<Uint8List> _applySelectedFilter(int index) async {
    var receivePort = ReceivePort();
    var imageToFilter = _getCurrentImageToFilter();
    await Isolate.spawn(
        _applyFilterInIsolate,
        FilterIsolateData(
          sendPort: receivePort.sendPort,
          image: img.copyResize(img.decodeImage(imageToFilter)!,
              width: originalImage!.width),
          filter: FilterType.values[index],
        ));
    return await receivePort.first as Uint8List;
  }

  Uint8List _getCurrentImageToFilter() {
    return (currentEditIndex >= 0 && currentEditIndex < editHistory.length)
        ? editHistory[currentEditIndex]
        : File(imagePath).readAsBytesSync();
  }

  void applyEdit() {
    if (imageBytes != null) {
      if (currentEditIndex < editHistory.length - 1) {
        editHistory.removeRange(currentEditIndex + 1, editHistory.length);
      }

      editHistory.add(imageBytes!);
      currentEditIndex = editHistory.length - 1;

      toggleOptions();
      notifyListeners();
    }
  }

  void undoEdit() {
    if (canUndo) {
      currentEditIndex--;
      imageBytes = editHistory[currentEditIndex];
      notifyListeners();
    }
  }

  void redoEdit() {
    if (canRedo) {
      currentEditIndex++;
      imageBytes = editHistory[currentEditIndex];
      notifyListeners();
    }
  }
}
