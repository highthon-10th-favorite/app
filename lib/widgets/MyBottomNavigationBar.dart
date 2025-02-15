import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return DotCurvedBottomNav(
      indicatorColor: text.white,
      backgroundColor: text.white,
      selectedColor: accent.primary,
      unSelectedColor: text.primary,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.ease,
      selectedIndex: widget.currentIndex,
      indicatorSize: 7,
      borderRadius: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      height: 75,
      strokeColor: text.quaternary,
      circleStrokeColor: text.quaternary,
      onTap: (index) {
          setState(() => widget.onTap(index));
        },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/svgs/chat.svg',
            color: widget.currentIndex == 0 ? accent.primary : text.primary,
          ),
          label: "채팅",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/svgs/home.svg',
            color: widget.currentIndex == 1 ? accent.primary : text.primary,
          ),
          label: "홈",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/svgs/profile.svg',
            color: widget.currentIndex == 2 ? accent.primary : text.primary,
          ),
          label: "프로필",
        ),
      ],
    );
  }
}