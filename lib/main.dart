import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:highthon_10th_favorite/pages/MainPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => const MainPage())
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
