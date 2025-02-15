import 'package:flutter/material.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

ThemeData initThemeData({required Brightness brightness}) {
  if (brightness == Brightness.light) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      ),
      fontFamily: 'Moneygraphy'
    );
  } else {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      ),
      fontFamily: 'Moneygraphy'
    );
  }
}