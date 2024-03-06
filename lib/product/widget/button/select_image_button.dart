import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:pixvibe_clone/product/extension/icon_size_extension.dart';

import '../../enum/size/icon_size.dart';

class SelectImageButton extends StatelessWidget {
  const SelectImageButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.color,
  });

  final Function() onPressed;
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: IconSize.extraLarge.dynamicValue(context),
          ),
          Text(text).tr(),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(context.sized.dynamicHeight(0.01)),
        ),
      ),
    );
  }
}
