import 'dart:ui';

class TextColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color quaternary;
  final Color white;

  const TextColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.quaternary,
    required this.white,
  });
}

class AccentColors {
  final Color primary;

  const AccentColors({required this.primary});
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

const text = TextColors(
  primary: Color(0xff101016),
  secondary: Color(0xff6B6B6B),
  tertiary: Color(0xff9D9D9D),
  quaternary: Color(0xffCECECE),
  white: Color(0xffFFFFFF),
);

const accent = AccentColors(
  primary: Color(0xffB90FFF),
);

const brand = BrandColors(
  kakao: Color(0xffFCC737),
  naver: Color(0xff57CB76),
  facebook: Color(0xff3479F5),
);
