import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pixvibe_clone/core/constants/string_constants.dart';
import 'package:pixvibe_clone/core/init/localization/product_localization.dart';
import 'package:pixvibe_clone/core/init/theme/app_theme.dart';

import 'core/init/start/application_start.dart';
import 'feature/home/home_page.dart';

Future<void> main() async {
  await ApplicationStart.init();
  runApp(ProductLocalization(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConstants.appName,
      theme: AppTheme(context).theme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: ProductLocalization.getDeviceLocale(context: context),
      home: const HomePage(),
    );
  }
}
