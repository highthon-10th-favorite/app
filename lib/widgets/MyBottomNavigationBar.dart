import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.06;
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: iconSize),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: iconSize),
              label: "홈",
            ),
          ],
          selectedItemColor: const Color(0xff3B6DFF),
          unselectedItemColor: const Color(0xffD1D2D1),
        );
      },
    );
  }
}