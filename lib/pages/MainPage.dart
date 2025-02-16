import 'package:flutter/material.dart';
import 'package:highthon_10th_favorite/pages/main/ChatPage.dart';
import 'package:highthon_10th_favorite/pages/main/HomePage.dart';
import 'package:highthon_10th_favorite/pages/main/ProfilePage.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';
import 'package:highthon_10th_favorite/widgets/MyBottomNavigationBar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;
  final pages = [
    const ChatPage(),
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final text = TextColors.of(context);
    return Scaffold(
      backgroundColor: text.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: text.white,
          scrolledUnderElevation: 0,
        )
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}