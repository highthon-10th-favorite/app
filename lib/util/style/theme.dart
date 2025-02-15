import 'package:flutter/material.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

ThemeData initThemeData({required Brightness brightness}) {
  if (brightness == Brightness.light) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: text.primary,
        secondary: text.secondary,
        tertiary: text.tertiary,
      ),
      fontFamily: 'Moneygraphy'
    );
  } else {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: text.primary,
        secondary: text.secondary,
        tertiary: text.tertiary,
      ),
      fontFamily: 'Moneygraphy'
    );
  }
}