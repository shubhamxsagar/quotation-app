import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppPallete {
  static const Color backgroundColor = Color.fromRGBO(16, 74, 162, 1);

  static const Color primary = Color.fromRGBO(16, 74, 162, 1);
  static const Color gradient1 = Color.fromRGBO(54, 109, 192, 1);
  static const Color gradient2 = Color.fromRGBO(114, 146, 193, 1);
  static const Color gradient3 = Color.fromRGBO(1, 29, 69, 1);
  static const Color gradient4 = Color.fromRGBO(0, 21, 51, 1);

  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color transparentColor = Colors.transparent;
  static const Color black = Colors.transparent;
}

class AppTheme {
  static final lightThemeMode = ThemeData.light().copyWith(
    textTheme: _textTheme,
    scaffoldBackgroundColor: AppPallete.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.whiteColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPallete.whiteColor,
      shape: StadiumBorder(),
    ),
  );

  static const TextTheme _textTheme = TextTheme(
    displayMedium: TextStyle(
      fontFamily: 'OPTIMA',
      color: Colors.black,
    ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(AppTheme.lightThemeMode);

  static final ThemeData _darkTheme = AppTheme.lightThemeMode.copyWith(
    textTheme: _textTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppTheme.lightThemeMode.appBarTheme.copyWith(
      backgroundColor: Colors.white,
    ),
  );

  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: 'OPTIMA',
      color: Colors.black,
    ),
  );

  void toggleTheme() {
    state =
        state == AppTheme.lightThemeMode ? _darkTheme : AppTheme.lightThemeMode;
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
