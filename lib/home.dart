// File: lib/home.dart

import 'package:flutter/material.dart';
import 'input_page.dart';

// --- DEFINISI WARNA (Konsisten dengan login_page.dart) ---
const Color _kPrimaryPink = Color(0xFFFF699F); 
const Color _kLightPinkBackground = Color(0xFFFDEEF2); 

// HomePage sekarang NON-CONST agar lebih fleksibel
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Menghapus const dari Scaffold
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          const _HomeSliverAppBar(), // Ini tetap const karena isinya konstan
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20.0), 
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                // PERBAIKAN: HAPUS SEMUA 'const' DI SINI
                [ 
                  const _AnalysisCard(), // Membiarkan const di sini (atau bisa dihapus juga)
                  const _FeaturesSection(), 
                  const _StatsSection(), 
                  const SizedBox(height: 20.0), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Komponen A: AppBar Custom (CONST) ---
class _HomeSliverAppBar extends StatelessWidget {
  const _HomeSliverAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      expandedHeight: 120.0,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Selamat Datang di',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87.withOpacity(0.7),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'SkinMatch',
              style: TextStyle(
                fontSize: 22,
                color: _kPrimaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Komponen B: Kartu Analisis Kulit (CONST) ---
class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard(); // Konstruktor konstan

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: _kPrimaryPink.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: _kPrimaryPink.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome, color: _kPrimaryPink, size: 24),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Analisis Kulit Personal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Dapatkan rekomendasi produk skincare yang tepat sesuai dengan kondisi kulitmu.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _kPrimaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Mulai Analisis Kulit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Komponen C: Fitur Unggulan (CONST) ---
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection(); // Konstruktor konstan

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 25.0, top: 30.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Text(
              'Fitur Unggulan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 15),
          _FeatureItem(
            icon: Icons.psychology_outlined, 
            title: 'Rekomendasi Cerdas',
            description:
                'Sistem rekomendasi berbasis decision tree yang menganalisis kebutuhan kulitmu secara akurat',
          ),
          _FeatureItem(
            icon: Icons.person_pin_outlined,
            title: 'Personalisasi Lengkap',
            description:
                'Rekomendasi disesuaikan dengan jenis kulit, masalah kulit, dan budget yang kamu miliki',
          ),
          _FeatureItem(
            icon: Icons.verified_user_outlined,
            title: 'Produk Terpercaya',
            description:
                'Hanya merekomendasikan produk dari brand ternama dan terpercaya di Indonesia',
          ),
        ],
      ),
    );
  }
}

// Widget untuk setiap item fitur
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    super.key, 
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 25.0, bottom: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kLightPinkBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _kPrimaryPink, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Komponen D: Statistik (CONST) ---
class _StatsSection extends StatelessWidget {
  const _StatsSection(); // Konstruktor konstan

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _StatItem(count: '500+', label: 'Produk'),
          _StatItem(count: '50+', label: 'Brand'),
          _StatItem(count: '10K+', label: 'Pengguna'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label}); // Konstruktor konstan

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _kPrimaryPink,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}