import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:highthon_10th_favorite/api/UserApi.dart';
import 'package:highthon_10th_favorite/main.dart';
import 'package:highthon_10th_favorite/pages/MainPage.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user?.uid;

      Get.off(() => const MainPage());

      // UserApi().getUserById(uid!).then((user) {
      //   if (user.isEmpty) {
      //     Get.off(() => const MainPage());
      //   }
      // });
    } catch (error) {
      print("구글 로그인 에러: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08;
    final verticalPadding = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenWidth * 0.05),
                  SizedBox(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.16,
                    child: SvgPicture.asset('assets/svgs/love_cn.svg'),
                  ),
                  SizedBox(height: screenWidth * 0.08),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '최애',
                          style: TextStyle(
                            color: Color(0xFFB90EFF),
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'Moneygraphy',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '에 오신 것을 \n환영합니다!',
                          style: TextStyle(
                            color: Color(0xFF101016),
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'Moneygraphy',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.4),
                  GestureDetector(
                    onTap: () {
                      print("카카오 로그인 구현 예정");
                    },
                    child: SocialLoginButton(
                      text: '카카오로 계속하기',
                      borderColor: brand.kakao,
                      textColor: brand.kakao,
                      logoSize: screenWidth * 0.045,
                      logo: SvgPicture.asset(
                        'assets/svgs/kakao_logo.svg',
                        color: brand.kakao,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  GestureDetector(
                    onTap: () {
                      print("네이버 로그인 구현 예정");
                    },
                    child: SocialLoginButton(
                      text: '네이버로 계속하기',
                      borderColor: brand.naver,
                      textColor: brand.naver,
                      logoSize: screenWidth * 0.045,
                      logo: SvgPicture.asset(
                        'assets/svgs/naver_logo.svg',
                        color: brand.naver,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  GestureDetector(
                    onTap: () {
                      print("페이스북 로그인 구현 예정");
                    },
                    child: SocialLoginButton(
                      text: '페이스북으로 계속하기',
                      borderColor: brand.facebook,
                      textColor: brand.facebook,
                      logoSize: screenWidth * 0.055,
                      logo: SvgPicture.asset(
                        'assets/svgs/facebook_logo.svg',
                        color: brand.facebook,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  GestureDetector(
                    onTap: _handleGoogleSignIn,
                    child: SocialLoginButton(
                      text: '구글로 계속하기',
                      borderColor: accent.primary,
                      textColor: accent.primary,
                      logoSize: screenWidth * 0.05,
                      logo: SvgPicture.asset(
                        'assets/svgs/google_logo.svg',
                        color: accent.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color textColor;
  final double logoSize;
  final Widget logo;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.borderColor,
    required this.textColor,
    required this.logoSize,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.85;
    return Container(
      width: buttonWidth,
      height: 50,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.5, color: borderColor),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: logoSize,
            height: logoSize,
            child: logo,
          ),
          SizedBox(width: buttonWidth * 0.02),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontFamily: 'Moneygraphy',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
