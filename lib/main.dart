import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parlai/view/splash/landing.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.green, // Android legacy
          statusBarIconBrightness: Brightness.light, // Android icons
          statusBarBrightness: Brightness.dark, // iOS icons
        ),
        child: const SplashScreen(),
      ),
    );
  }
}
