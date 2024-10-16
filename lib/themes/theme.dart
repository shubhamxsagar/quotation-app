import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotation/themes/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.whiteColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        AppPallete.whiteColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor),
    ),
  );
}
