import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:pixvibe_clone/core/constants/string_constants.dart';

import '../../product/base/base_widget.dart';
import '../../product/init/language/locale_keys.g.dart';
import '../../product/widget/button/select_image_button.dart';
import 'home_page_view_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (viewModel) async {
        await viewModel.loadGalleryHeaders();
        await viewModel.loadImages(viewModel.selectedHeader);
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.appName),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildButtonsRow(viewModel, context),
              _buildHeadersList(viewModel, context),
              _buildImagesGrid(viewModel, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonsRow(HomeViewModel viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SelectImageButton(
          onPressed: () => viewModel.selectImage(context),
          icon: Icons.image_outlined,
          text: LocaleKeys.home_gallery,
          color: Colors.purple,
        ),
        SelectImageButton(
          onPressed: () async => await viewModel.takePhoto(context),
          icon: Icons.camera_alt_outlined,
          text: LocaleKeys.home_camera,
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildHeadersList(HomeViewModel viewModel, BuildContext context) {
    return SizedBox(
      height: context.sized.dynamicHeight(0.1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.galleryHeaders.length,
        itemBuilder: (context, index) {
          final bool isSelected = viewModel.selectedIndex == index;
          return GestureDetector(
            onTap: () {
              viewModel.onTapHeaderChip(index);
            },
            child: Chip(
              label: Text(viewModel.galleryHeaders[index]),
              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagesGrid(HomeViewModel viewModel, BuildContext context) {
    return SizedBox(
      height: context.sized.dynamicHeight(0.3),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: viewModel.imageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => viewModel.navigateToEditPageWithImage(
                context, viewModel.imageList[index].path),
            child: Image.file(
              viewModel.imageList[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
