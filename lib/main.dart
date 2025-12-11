// File: lib/main.dart

import 'package:flutter/material.dart';
// Import file login
import 'login_page.dart'; 
// Import MainNavigator yang baru dibuat

void main() {
  runApp(const SkinMatchApp());
}

class SkinMatchApp extends StatelessWidget {
  const SkinMatchApp({super.key});

  static const Color _kPrimaryPink = Color(0xFFFF699F); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare Recommender',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          accentColor: _kPrimaryPink,
        ).copyWith(
          primary: _kPrimaryPink,
          secondary: _kPrimaryPink,
        ),
        primarySwatch: Colors.pink,
        primaryColor: _kPrimaryPink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kPrimaryPink,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
