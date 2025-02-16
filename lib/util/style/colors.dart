import 'dart:ui';

import 'package:flutter/material.dart';

class TextColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color quaternary;
  final Color white;

  TextColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.quaternary,
    required this.white,
  });

  static TextColors of(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextColors(
      primary: isDarkMode ? const Color(0xffFFFFFF) : const Color(0xff101016),
      secondary: isDarkMode ? const Color(0xffCECECE) : const Color(0xff6B6B6B),
      tertiary: const Color(0xff9D9D9D),
      quaternary: isDarkMode ? const Color(0xff6B6B6B) : const Color(0xffCECECE),
      white: isDarkMode ? const Color(0xff101016) : const Color(0xffFFFFFF),
    );
  }
}

class AccentColors {
  final Color primary;
  final Color warning;

  AccentColors({required this.primary, required this.warning});

  static AccentColors of(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AccentColors(
      primary: isDarkMode ? const Color(0xffE49BFF) : const Color(0xffB90FFF),
      warning: const Color(0xffFF1414),
    );
  }
}

class BrandColors {
  final Color kakao;
  final Color naver;
  final Color facebook;

  const BrandColors({
    required this.kakao,
    required this.naver,
    required this.facebook,
  });
}

const brand = BrandColors(
  kakao: Color(0xffFCC737),
  naver: Color(0xff57CB76),
  facebook: Color(0xff3479F5),
);
