// lib/main.dart

import 'package:flutter/material.dart';
import 'package:skinmatch_flutter/input_page.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare Recommender',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ... (Kode theme Anda tetap) ...
        primarySwatch: Colors.pink, 
        primaryColor: const Color(0xFFF392A0), 
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
      ),
      // UBAH: Gunakan nama kelas yang benar, yaitu InputPage
      home: const InputPage(), 
    );
  }
}