import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController introController = TextEditingController();

  String? selectedGender = '여성';
  String? preferredGender = '남성';
  String? _selectedImagePath;

  bool _isValidNickname = false;
  bool _isValidNext = false;

  @override
  void dispose() {
    nicknameController.dispose();
    heightController.dispose();
    ageController.dispose();
    jobController.dispose();
    introController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nicknameController.addListener(_validateNickname);
    heightController.addListener(_validateNext);
    ageController.addListener(_validateNext);
    jobController.addListener(_validateNext);
    introController.addListener(_validateNext);
  }

  void _validateNickname() {
    final nickname = nicknameController.text.trim();
    setState(() {
      _isValidNickname = nickname.length >= 2;
    });
  }

  void _validateNext() {
    final height = heightController.text.trim();
    final age = ageController.text.trim();
    final job = jobController.text.trim();
    final intro = introController.text.trim();
    setState(() {
      _isValidNext = _selectedImagePath != null && _selectedImagePath!.isNotEmpty && height.isNotEmpty && age.isNotEmpty && job.isNotEmpty && intro.isNotEmpty
            && _isValidNickname && int.tryParse(height) != null && RegExp(r'^\d{4}/\d{2}/\d{2}$').hasMatch(age);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text1 = TextColors.of(context);
    final accent1 = AccentColors.of(context);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    
    final horizontalPadding = size.width * 0.08;
    final profileSize = size.width * 0.3;
    final buttonHeight = size.height * 0.07;
    
    return Scaffold(
      backgroundColor: text1.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/svgs/progress_bar.svg',
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  '회원가입을 위해 \n필수 항목들을 작성해 주세요!',
                  style: TextStyle(
                    color: text1.primary,
                    fontSize: size.width * 0.05,
                    fontFamily: 'Moneygraphy',
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Center(
                  child: _selectedImagePath == null
                    ? GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: SvgPicture.asset(
                        'assets/svgs/profile_add.svg',
                        width: profileSize,
                        height: profileSize,
                      ),
                    )
                  : Container(
                      width: profileSize,
                      height: profileSize,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: FileImage(File(_selectedImagePath!)),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                ),
                SizedBox(height: size.height * 0.04),
                _buildInputField(context, '닉네임', '사용자 닉네임을 입력해 주세요', true,
                    controller: nicknameController, hasButton: true),
                _buildInputField(context, '성별', '', true, isGender: true),
                _buildInputField(context, '선호하는 성별', '', true,
                    isGender: true, isReversed: true),
                _buildInputField(context, '키', '사용자분의 키를 입력해 주세요.', true,
                    controller: heightController),
                _buildInputField(context, '나이', '예) 2006/12/20', true,
                    controller: ageController),
                _buildInputField(context, '직업', '사용자분의 직업을 입력해 주세요.', false,
                    controller: jobController),
                _buildInputField(context, '한줄소개', '사용자분의 한마디를 적어주세요.', true,
                    controller: introController),
                SizedBox(height: size.height * 0.04),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isValidNext
                          ? accent1.primary
                          : text1.quaternary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.08),
                      ),
                      minimumSize: Size(size.width * 0.84, buttonHeight),
                    ),
                    onPressed: () {
                      
                    },
                    child: Text(
                      '다음으로',
                      style: TextStyle(
                        color: _isValidNext
                            ? text1.white
                            : text1.tertiary,
                        fontSize: size.width * 0.05,
                        fontFamily: 'Moneygraphy',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Widget _buildInputField(
    BuildContext context,
    String label,
    String hint,
    bool isRequired, {
    TextEditingController? controller,
    bool hasButton = false,
    bool isGender = false,
    bool isReversed = false,
  }) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.035;
    final inputHeight = size.height * 0.05;
    final text1 = TextColors.of(context);
    final accent1 = AccentColors.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: text1.primary,
                  fontSize: fontSize,
                  fontFamily: 'Moneygraphy',
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: accent1.primary,
                    fontSize: fontSize,
                    fontFamily: 'Moneygraphy',
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.005),
          isGender
              ? Row(
                  children: [
                    _buildGenderButton(
                      context, 
                      '여성', 
                      isReversed 
                          ? (preferredGender == '여성')
                          : (selectedGender == '여성'),
                      onTap: () {
                        setState(() {
                          if (isReversed) {
                            preferredGender = '여성';
                          } else {
                            selectedGender = '여성';
                          }
                        });
                      },
                    ),
                    SizedBox(width: size.width * 0.02),
                    _buildGenderButton(
                      context, 
                      '남성', 
                      isReversed 
                          ? (preferredGender == '남성')
                          : (selectedGender == '남성'),
                      onTap: () {
                        setState(() {
                          if (isReversed) {
                            preferredGender = '남성';
                          } else {
                            selectedGender = '남성';
                          }
                        });
                      },
                    ),
                  ],
                )
              : Container(
                  height: inputHeight,
                  decoration: BoxDecoration(
                    color: text1.quaternary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: TextStyle(
                            color: text1.primary,
                            fontSize: fontSize,
                            fontFamily: 'Moneygraphy',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: TextStyle(
                              color: text1.quaternary,
                              fontSize: fontSize,
                              fontFamily: 'Moneygraphy',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.014,
                            ),
                          ),
                        ),
                      ),
                      if (hasButton)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.01,
                            vertical: size.height * 0.004
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isValidNickname
                                  ? accent1.primary
                                  : text1.quaternary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              '중복확인',
                              style: TextStyle(
                                color: _isValidNickname
                                    ? text1.white
                                    : text1.tertiary,
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context, 
    String text, 
    bool isSelected, 
    {VoidCallback? onTap}
  ) {
    final size = MediaQuery.of(context).size;
    final inputHeight = size.height * 0.05;
    final fontSize = size.width * 0.035;
    final text1 = TextColors.of(context);
    final accent1 = AccentColors.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: inputHeight,
          decoration: BoxDecoration(
            color: isSelected
                ? accent1.primary
                : text1.quaternary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(inputHeight),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? text1.white : text1.quaternary,
                fontSize: fontSize,
                fontFamily: 'Moneygraphy',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}