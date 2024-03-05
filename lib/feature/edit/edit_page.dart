import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../product/base/base_widget.dart';
import 'edit_page_view_model.dart';

class EditPage extends StatelessWidget {
  final String imagePath;

  const EditPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<EditViewModel>(
      viewModel: EditViewModel(imagePath),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: const Text('Edit Image')),
        body: _buildBody(context, model),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EditViewModel model) {
    return model.imageBytes == null
        ? const Center(child: CircularProgressIndicator())
        : _buildImageEditor(context, model);
  }

  Widget _buildImageEditor(BuildContext context, EditViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        children: [
          _buildImagePreview(model),
          model.showPreview
              ? _buildFilterPreview(context, model)
              : _buildEditOptions(model),
        ],
      ),
    );
  }

  Widget _buildImagePreview(EditViewModel model) {
    return Expanded(
      flex: 5,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.memory(model.imageBytes!, fit: BoxFit.cover),
            ),
          ),
          _buildUndoRedoButtons(model),
        ],
      ),
    );
  }

  Widget _buildUndoRedoButtons(EditViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildIconButton(Icons.undo, model.canUndo, model.undoEdit),
          _buildIconButton(Icons.redo, model.canRedo, model.redoEdit),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, bool condition, VoidCallback? action) {
    return IconButton(
      icon: Icon(icon, color: condition ? Colors.white : Colors.grey),
      onPressed: condition ? action : null,
    );
  }

  Widget _buildFilterPreview(BuildContext context, EditViewModel model) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: _buildFilterListView(context, model),
          ),
          _buildApplyCancelButtonRow(model),
        ],
      ),
    );
  }

  Widget _buildFilterListView(BuildContext context, EditViewModel model) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: model.filterPreviews.length,
      itemBuilder: (context, index) => model.isLoadingPreview
          ? const Center(child: CircularProgressIndicator())
          : _buildFilterItem(context, model, index),
    );
  }

  Widget _buildFilterItem(
      BuildContext context, EditViewModel model, int index) {
    return GestureDetector(
      onTap: () => model.setActiveFilter(index),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              FilterType.values[index].name,
              style: context.general.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
            Expanded(
              flex: 4,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.memory(model.filterPreviews[index],
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyCancelButtonRow(EditViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: model.toggleOptions),
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: model.applyEdit),
      ],
    );
  }

  Widget _buildEditOptions(EditViewModel model) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: model.toggleOptions, child: const Text("Filter")),
          ElevatedButton(onPressed: () {}, child: const Text("Tune")),
        ],
      ),
    );
  }
}
