import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/locals.dart';

@immutable
final class ProductLocalization extends EasyLocalization {
  ProductLocalization({
    required super.child,
    super.key,
  }) : super(
          supportedLocales: _supportedItems,
          path: _translationPath,
          useOnlyLangCode: true,
        );

  static final List<Locale> _supportedItems = [
    Locales.en.locale,
    Locales.tr.locale
  ];

  static const String _translationPath = 'assets/translations';

  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales value,
  }) =>
      context.setLocale(value.locale);

  // get device locale
  static Locale? getDeviceLocale({
    required BuildContext context,
  }) {
    return context.locale;
  }
}
