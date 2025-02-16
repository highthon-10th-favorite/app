import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:highthon_10th_favorite/pages/MainPage.dart';
import 'package:highthon_10th_favorite/pages/auth/SignUpPage.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

class SMSVerifyPage extends StatefulWidget {
  const SMSVerifyPage({super.key});

  @override
  _SMSVerifyPageState createState() => _SMSVerifyPageState();
}

class _SMSVerifyPageState extends State<SMSVerifyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _verificationId;
  bool _isValidPhoneNumber = false;
  bool _isValidOTP = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumber);
    _codeController.addListener(_validateOTP);
  }

  void _validatePhoneNumber() {
    final phoneNumber = _phoneController.text.trim();
    setState(() {
      _isValidPhoneNumber = RegExp(r'^(010)-?[0-9]{4}-?[0-9]{4}$').hasMatch(phoneNumber);
    });
  }

  void _validateOTP() {
    final otp = _codeController.text.trim();
    setState(() {
      _isValidOTP = otp.length == 6;
    });
  }

  void _verifyPhoneNumber() async {
    if (!_isValidPhoneNumber) return;
    
    await _auth.verifyPhoneNumber(
      phoneNumber: '+82${_phoneController.text.trim().substring(1)}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("자동 인증 성공!")),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("인증 실패: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("인증 코드가 전송되었습니다.")),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 120),
    );
  }

  void _signInWithOTP() async {
    if (_verificationId == null) return;
    
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _codeController.text.trim(),
    );

    try {
      await _auth.signInWithCredential(credential);
      Get.offAll(() => const SignUpPage());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("인증 실패")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.035;
    final text = TextColors.of(context);
    final accent = AccentColors.of(context);

    return Scaffold(
      backgroundColor: text.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/svgs/arrow_left.svg',
                  color: text.primary,
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SvgPicture.asset(
                'assets/svgs/shield.svg',
                color: accent.primary,
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                '원활한 커뮤니티 운영을 위해 :) ',
                style: TextStyle(
                  color: accent.primary,
                  fontSize: screenWidth * 0.04,
                  fontFamily: 'Moneygraphy',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                '회원가입 및 로그인을 위해\n본인 인증을 진행해주세요.',
                style: TextStyle(
                  color: text.primary,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'Moneygraphy',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontSize: fontSize,
                  color: text.primary,
                  fontFamily: 'Moneygraphy',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: text.quaternary.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '전화번호를 입력해 주세요.',
                  hintStyle: TextStyle(
                    color: text.quaternary,
                    fontSize: fontSize,
                    fontFamily: 'Moneygraphy',
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.012,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.004),
                    child: ElevatedButton(
                      onPressed: _isValidPhoneNumber ? _verifyPhoneNumber : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isValidPhoneNumber ? accent.primary : text.quaternary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        '인증하기',
                        style: TextStyle(
                          color: _isValidPhoneNumber ? text.white : text.tertiary,
                          fontSize: fontSize,
                          fontFamily: 'Moneygraphy',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: fontSize,
                  color: text.primary,
                  fontFamily: 'Moneygraphy',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: text.quaternary.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '인증번호 입력하기',
                  hintStyle: TextStyle(
                    color: text.quaternary,
                    fontSize: fontSize,
                    fontFamily: 'Moneygraphy',
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.012,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _isValidOTP ? _signInWithOTP : null,
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.07,
                  decoration: ShapeDecoration(
                    color: _isValidOTP ? accent.primary : text.quaternary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "다음으로",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isValidOTP ? text.white : text.tertiary,
                        fontSize: 20,
                        fontFamily: 'Moneygraphy',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhoneNumber);
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}