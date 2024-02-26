import 'package:flutter/material.dart';

@immutable
class AppTheme {
  const AppTheme(this.context);
  final BuildContext context;

  ThemeData get theme => ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        scaffoldBackgroundColor: Colors.black,
      );
}
