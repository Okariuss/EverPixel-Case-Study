import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../cache/app_cache.dart';

@immutable
class ApplicationStart {
  const ApplicationStart._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await AppCache.instance.setup();
  }
}
