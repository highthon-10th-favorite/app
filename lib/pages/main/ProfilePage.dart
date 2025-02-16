import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highthon_10th_favorite/api/UserApi.dart';
import 'package:highthon_10th_favorite/pages/auth/LoginPage.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userDataFuture;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    userDataFuture = _loadUserData();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    return await UserApi().getUserById(user!.uid);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final text = TextColors.of(context);
    final accent = AccentColors.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: text.white,
        title: Text("프로필", style: TextStyle(color: text.primary)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: _signOut,
              child: Text("로그아웃",
                  style: TextStyle(color: accent.warning, fontSize: 20)),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null ||
              snapshot.data!['data'] == null ||
              snapshot.data!["data"]["profileImageUrl"] == null) {
            return Center(child: Text('${snapshot.data}'));
          }

          final userData = snapshot.data!;
          return Container(
            color: text.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildProfileHeader(userData, size),
                _buildActionButtons(),
                const SizedBox(
                  height: 20,
                ),
                _buildHobbySection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: size.width * 0.3,
            height: size.width * 0.3,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(userData["data"]["profileImageUrl"]),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(userData["data"]["nickname"],
            style:
                TextStyle(color: TextColors.of(context).primary, fontSize: 25)),
        const SizedBox(height: 0),
        Text(userData["data"]["introduction"],
            style:
                TextStyle(color: TextColors.of(context).primary, fontSize: 15)),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(text: '프로필 수정', onPressed: () {}),
        const SizedBox(width: 5),
        _buildActionButton(text: '찜 목록 보기', onPressed: () {}),
      ],
    );
  }

  Widget _buildHobbySection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('취미',
                style: TextStyle(
                    color: TextColors.of(context).primary, fontSize: 20)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                _buildActionButton(text: "🛩 여행하기", onPressed: () {}),
                const SizedBox(width: 10),
                _buildActionButton(text: "🧽 청소하기", onPressed: () {}),
                const SizedBox(width: 10),
                _buildActionButton(text: "🍳 요리하기", onPressed: () {}),
              ],
            ))
      ],
    );
  }

  Widget _buildActionButton(
      {required String text, required VoidCallback onPressed}) {
    final text1 = TextColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: ShapeDecoration(
        color: text1.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: text1.tertiary),
          borderRadius: BorderRadius.circular(49),
        ),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Text(text, style: TextStyle(color: text1.primary, fontSize: 15)),
      ),
    );
  }
}
