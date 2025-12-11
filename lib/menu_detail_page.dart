// File: lib/menu_detail_page.dart (FINAL & NYAMBUNG)

import 'package:flutter/material.dart';

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F);
const Color _kLightPinkBackground = Color(0xFFFDEEF2);

class MenuDetailPage extends StatelessWidget {
  final String title;

  const MenuDetailPage({super.key, required this.title});

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Notifikasi':
        return Icons.notifications_none;
      case 'Privasi & Keamanan':
        return Icons.lock_outline;
      case 'Bantuan & Dukungan':
        return Icons.help_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData pageIcon = _getIconForTitle(title);

    return Scaffold(
      backgroundColor: _kLightPinkBackground,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: _kLightPinkBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(pageIcon, size: 80, color: _kPrimaryPink),
              const SizedBox(height: 20),
              Text(
                'Halaman $title',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Detail informasi akan dimuat di sini setelah tersedia.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}