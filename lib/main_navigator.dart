// File: lib/main_navigator.dart 

import 'package:flutter/material.dart';

import 'profile_page.dart'; 
import 'home.dart'; 
import 'explore.dart'; 
import 'wishlist_page.dart'; 

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F);

class MainNavigator extends StatefulWidget {
  const MainNavigator({
    super.key,
  });

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  
  // Menggunakan 'late final' untuk inisialisasi di initState
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Inisialisasi list halaman
    _pages = <Widget>[
      const HomePage(), 
      const ExplorePage(), 
      const WishlistPage(), 
      const ProfilePage(), // Dipanggil tanpa parameter karena sudah ambil dari storage
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), 
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _kPrimaryPink, 
        unselectedItemColor: Colors.grey, 
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed, 
      ),
    );
  }
}