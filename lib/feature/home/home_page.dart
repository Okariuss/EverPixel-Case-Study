import 'package:flutter/material.dart';
import 'package:pixvibe_clone/core/constants/string_constants.dart';

import '../../product/base/base_widget.dart';
import '../../product/init/language/locale_keys.g.dart';
import '../../product/widget/button/select_image_button.dart';
import 'home_page_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (model) {
        viewModel = model;
      },
      builder: (context, viewModel, child) => _scaffoldBody,
    );
  }

  Widget get _scaffoldBody => Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.appName),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SelectImageButton(
              onPressed: () => viewModel.selectImage(context),
              icon: Icons.image_outlined,
              text: LocaleKeys.home_gallery,
              color: Colors.purple,
            ),
            SelectImageButton(
              onPressed: () => viewModel.takePhoto(context),
              icon: Icons.camera_alt_outlined,
              text: LocaleKeys.home_camera,
              color: Colors.redAccent,
            ),
          ],
        ),
      );
}
