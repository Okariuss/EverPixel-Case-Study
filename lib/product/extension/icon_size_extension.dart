import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../enum/size/icon_size.dart';

extension IconSizeExtension on IconSize {
  double dynamicValue(BuildContext context) {
    switch (this) {
      case IconSize.small:
        return context.sized.dynamicHeight(0.02); // 2% of device height
      case IconSize.normal:
        return context.sized.dynamicHeight(0.03); // 3% of device height
      case IconSize.medium:
        return context.sized.dynamicHeight(0.04); // 4% of device height
      case IconSize.large:
        return context.sized.dynamicHeight(0.06); // 6% of device height
      case IconSize.extraLarge:
        return context.sized.dynamicHeight(0.12); // 12% of device height
    }
  }
}
