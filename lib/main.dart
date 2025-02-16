import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:highthon_10th_favorite/firebase_options.dart';
import 'package:highthon_10th_favorite/pages/MainPage.dart';
import 'package:highthon_10th_favorite/pages/auth/LoginPage.dart';
import 'package:highthon_10th_favorite/pages/auth/SMSVerifyPage.dart';
import 'package:highthon_10th_favorite/util/style/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'assets/config/.env');

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
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/verify', page: () => const SMSVerifyPage()),
      ],
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      theme: initThemeData(brightness: Brightness.light),
      darkTheme: initThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
