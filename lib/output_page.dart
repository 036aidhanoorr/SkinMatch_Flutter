// File: lib/output_page.dart

import 'package:flutter/material.dart';

// --- DEFINISI WARNA & KONSTANTA ---
const Color _kPrimaryPink = Color(0xFFFF699F); 
const Color _kLightPinkBackground = Color(0xFFFDEEF2); 
const Color _kLightBlueBackground = Color(0xFFEEF5FF); // Untuk background Tips Penggunaan
const Color _kSecondaryPurple = Color(0xFFAB66CC); // Untuk Tips Umum Skincare
const Color _kHintGrey = Color(0xFF8D8D8D); 

// ====================================================================
// ==================== MODEL DATA (Untuk Kepentingan Output) ====================
// ====================================================================

// Model untuk data produk
class ProductRecommendation {
  final String brand;
  final String productName;
  final String imageUrl;
  final double price;

  ProductRecommendation({
    required this.brand,
    required this.productName,
    required this.imageUrl,
    required this.price,
  });
}

// Model untuk menyimpan detail setiap langkah rutinitas
class SkincareStep {
  final int stepNumber;
  final String title;
  final String description;
  final String usageTime; 
  final ProductRecommendation recommendation;
  final String usageTip;

  SkincareStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.usageTime,
    required this.recommendation,
    required this.usageTip,
  });
}

// ====================================================================
// ==================== SIMULASI DECISION TREE LOGIC ====================
// ====================================================================

class DecisionTreeLogic {
  final String skinType;
  final List<String> skinIssues;
  final double budget;

  DecisionTreeLogic({
    required this.skinType,
    required this.skinIssues,
    required this.budget,
  });

  // Helper untuk menentukan produk berdasarkan kriteria budget dan masalah
  ProductRecommendation _getProduct(String category, String issue, double budget) {
    // --- Cleanser ---
    if (category == 'Cleanser') {
      if (skinIssues.contains('Jerawat') && budget <= 100000) {
        return ProductRecommendation(
          brand: 'Skintific',
          productName: 'Acne Care Face Wash',
          imageUrl: 'assets/skintific_acne.png', 
          price: 75000,
        );
      }
      return ProductRecommendation(
        brand: 'Dear Me Beauty',
        productName: 'Gentle Cleanser',
        imageUrl: 'assets/dearme_cleanser.png',
        price: 99000,
      );
    } 
    
    // --- Toner ---
    if (category == 'Toner') {
      if (skinIssues.contains('Kusam') && budget <= 150000) {
        return ProductRecommendation(
          brand: 'Avoskin',
          productName: 'Brightening Toner',
          imageUrl: 'assets/avoskin_toner.png',
          price: 129000,
        );
      }
      return ProductRecommendation(
        brand: 'Hada Labo',
        productName: 'Gokujyun Premium Lotion',
        imageUrl: 'assets/hadalabo_toner.png',
        price: 110000,
      );
    }
    
    // --- Serum ---
    if (category == 'Serum') {
      if (skinIssues.contains('Noda Hitam') && budget <= 100000) {
        return ProductRecommendation(
          brand: 'Wardah',
          productName: 'Lightening Face Serum',
          imageUrl: 'assets/wardah_serum.png',
          price: 65000,
        );
      }
      return ProductRecommendation(
        brand: 'Somethinc',
        productName: 'Niacinamide Barrier Serum',
        imageUrl: 'assets/somethinc_serum.png',
        price: 135000,
      );
    }
    
    // --- Moisturizer ---
    if (category == 'Moisturizer') {
      if (skinType == 'Kering' || skinIssues.contains('Kulit Dehidrasi')) {
        return ProductRecommendation(
          brand: 'Cetaphil',
          productName: 'Hydrating Moisturizer',
          imageUrl: 'assets/cetaphil_moisturizer.png',
          price: 145000,
        );
      }
      return ProductRecommendation(
        brand: 'Azarine',
        productName: 'Oil-Free Moisturizer',
        imageUrl: 'assets/azarine_moist.png',
        price: 89000,
      );
    }
    
    // --- Sunscreen ---
    if (category == 'Sunscreen') {
       if (budget <= 70000) {
        return ProductRecommendation(
          brand: 'Biore',
          productName: 'UV Aqua Rich Watery Essence SPF 50',
          imageUrl: 'assets/biore_sunscreen.png',
          price: 55000,
        );
      }
       return ProductRecommendation(
        brand: 'Carasun',
        productName: 'Solar Smart UV Protector SPF 45',
        imageUrl: 'assets/carasun_sunscreen.png',
        price: 85000,
      );
    }
    
    return ProductRecommendation(brand: 'Generic', productName: 'Default Product', imageUrl: '', price: 0);
  }

  // Menjalankan logika Decision Tree untuk membuat rutinitas
  List<SkincareStep> generateRoutine() {
    final List<SkincareStep> routine = [];
    final String mainIssue = skinIssues.isNotEmpty ? skinIssues.first : 'Default';
    int step = 1;

    // 1. Pembersih Wajah
    routine.add(SkincareStep(
      stepNumber: step++,
      title: 'Pembersih Wajah',
      description: 'Bersihkan wajah dari kotoran, minyak, dan makeup',
      usageTime: 'Pagi & Malam',
      recommendation: _getProduct('Cleanser', mainIssue, budget),
      usageTip: 'Gunakan air hangat dan pijat lembut selama 30-60 detik. Bilas dengan air dingin untuk menutup pori-pori.',
    ));

    // 2. Toner (Opsional, diaktifkan jika kulit tidak Normal/Sensitif atau jika ada masalah Kusam)
    if (skinType != 'Normal' && skinType != 'Sensitif' || skinIssues.contains('Kusam')) {
      routine.add(SkincareStep(
        stepNumber: step++,
        title: 'Toner',
        description: 'Menyeimbangkan pH kulit dan mempersiapkan kulit untuk produk selanjutnya',
        usageTime: 'Pagi & Malam',
        recommendation: _getProduct('Toner', mainIssue, budget),
        usageTip: 'Tepuk-tepuk toner ke wajah dengan lembut menggunakan kapas atau tangan. Tunggu hingga meresap sebelum langkah berikutnya.',
      ));
    }

    // 3. Serum (Wajib untuk mengatasi masalah kulit)
    routine.add(SkincareStep(
      stepNumber: step++,
      title: 'Serum',
      description: 'Menutrisi dan merawat kulit',
      usageTime: 'Pagi & Malam',
      recommendation: _getProduct('Serum', mainIssue, budget),
      usageTip: 'Aplikasikan 2-3 tetes serum ke seluruh wajah. Tepuk-tepuk lembut agar meresap sempurna.',
    ));

    // 4. Pelembab (Wajib)
    routine.add(SkincareStep(
      stepNumber: step++,
      title: 'Pelembab',
      description: 'Mengunci kelembaban dan melindungi skin barrier',
      usageTime: 'Pagi & Malam',
      recommendation: _getProduct('Moisturizer', mainIssue, budget),
      usageTip: 'Gunakan seukuran kacang polong. Aplikasikan dengan gerakan ke atas untuk mencegah penuaan dini.',
    ));

    // 5. Sunscreen (Wajib Pagi)
    routine.add(SkincareStep(
      stepNumber: step++,
      title: 'Sunscreen',
      description: 'Melindungi kulit dari bahaya sinar UV',
      usageTime: 'Pagi (Wajib)',
      recommendation: _getProduct('Sunscreen', 'Default', budget),
      usageTip: 'Gunakan SPF minimal 30. Re-apply setiap 2-3 jam jika berada di luar ruangan. Jangan lupa leher dan telinga!',
    ));

    return routine;
  }
  
  // Menghitung total investasi
  double calculateTotalInvestment(List<SkincareStep> routine) {
    return routine.fold(0.0, (sum, item) => sum + item.recommendation.price);
  }
}

// ====================================================================
// ========================= WIDGET UTAMA (OutputPage) =================
// ====================================================================

class OutputPage extends StatelessWidget {
  final String skinType;
  final List<String> skinIssues;
  final double budget;

  const OutputPage({
    super.key,
    required this.skinType,
    required this.skinIssues,
    required this.budget,
  });

  // Helper untuk memformat budget
  String _formatCurrency(double value) {
    // Format Rupiah: 150000.0 menjadi "Rp 150.000"
    return 'Rp ${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    // Jalankan logika Decision Tree
    final logic = DecisionTreeLogic(
      skinType: skinType,
      skinIssues: skinIssues,
      budget: budget,
    );
    final routine = logic.generateRoutine();
    final totalInvestment = logic.calculateTotalInvestment(routine);
    
    // Tentukan ringkasan masalah (untuk tampilan dinamis di kartu pink)
    final String issueSummary;
    if (skinIssues.length == 1) {
      issueSummary = '1 masalah terpilih';
    } else if (skinIssues.length > 1) {
      issueSummary = '${skinIssues.length} masalah terpilih';
    } else {
      issueSummary = 'Tidak ada masalah terpilih';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.favorite_border, color: _kPrimaryPink),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // --- Header Rutinitas ---
                  const Text(
                    'Rutinitas Skincare',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'Untukmu', // Tambahan dari desain visual
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Ikuti langkah-langkah ini untuk hasil maksimal',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- Hasil Analisis dan Total Investasi Card (Pink Card) ---
                  _AnalysisSummaryCard(
                    skinType: skinType,
                    issueSummary: issueSummary,
                    budget: _formatCurrency(budget),
                    totalInvestment: _formatCurrency(totalInvestment),
                  ),
                  const SizedBox(height: 30),

                  // --- Daftar Langkah Rutinitas (Dynamic) ---
                  ...routine.map((step) => _RoutineStepItem(step: step)),
                  const SizedBox(height: 30),

                  // --- Tips Umum Skincare (Purple Card) ---
                  const _GeneralTipsCard(),
                  const SizedBox(height: 30),

                  // --- Tombol Aksi ---
                  _ActionExploreButton(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      // Navigasi bawah ditambahkan di main_navigator.dart, tidak perlu di sini
    );
  }
}

// ====================================================================
// ======================= KOMPONEN PEMBANGUN =========================
// ====================================================================

// Widget Kartu Hasil Analisis dan Total Investasi (Sesuai Desain Pink)
class _AnalysisSummaryCard extends StatelessWidget {
  final String skinType;
  final String issueSummary;
  final String budget;
  final String totalInvestment;

  const _AnalysisSummaryCard({
    required this.skinType,
    required this.issueSummary,
    required this.budget,
    required this.totalInvestment,
  });

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0, top: 8),
            child: Icon(Icons.circle, size: 8, color: Colors.white),
          ),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: _kPrimaryPink,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: _kPrimaryPink.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Hasil Analisis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _buildDetailItem('Jenis Kulit', skinType),
          _buildDetailItem('Masalah', issueSummary),
          _buildDetailItem('Budget', '$budget per produk'),
          
          const SizedBox(height: 15),
          
          // Total Investasi Rutinitas Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4), // Warna pink muda di dalam card
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Investasi Rutinitas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  totalInvestment,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

// Widget untuk menampilkan setiap Langkah Rutinitas (Pembersih, Toner, dll.)
class _RoutineStepItem extends StatelessWidget {
  final SkincareStep step;

  const _RoutineStepItem({required this.step});

  // Helper untuk format harga
  String _formatPrice(double value) {
     return 'Rp ${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card utama Langkah
        Container(
          // Card Luar (Putih)
          margin: const EdgeInsets.only(bottom: 10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Langkah (1, Pembersih Wajah)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _kPrimaryPink,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      step.stepNumber.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Label Waktu Penggunaan
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                             color: _kLightPinkBackground,
                             borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            step.usageTime,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _kPrimaryPink,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),
              
              // Divider di antara deskripsi dan rekomendasi
              const Divider(color: Colors.grey),

              // Produk Rekomendasi
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Produk Rekomendasi:',
                  style: TextStyle(
                    fontSize: 14,
                    color: _kHintGrey,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_size_select_actual_outlined, size: 30, color: _kHintGrey), 
                    // Ganti dengan Image.asset(step.recommendation.imageUrl) jika assets tersedia
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.recommendation.brand,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          step.recommendation.productName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatPrice(step.recommendation.price),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: _kPrimaryPink,
                              ),
                            ),
                            const Icon(Icons.favorite_border, color: _kHintGrey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Tips Penggunaan (Kotak Biru Muda)
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: _kLightBlueBackground,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tips Penggunaan:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.usageTip,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget Kartu Tips Umum Skincare (Purple Card)
class _GeneralTipsCard extends StatelessWidget {
  const _GeneralTipsCard();

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: _kSecondaryPurple, 
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: _kSecondaryPurple.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Tips Umum Skincare',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _buildTipItem('Konsistensi adalah kunci. Gunakan produk secara rutin 28 hari untuk melihat hasil.'),
          _buildTipItem('Minum air putih minimal 8 gelas per hari untuk menjaga hidrasi kulit dari dalam.'),
          _buildTipItem('Hindari menyentuh wajah terlalu sering untuk mencegah transfer bakteri.'),
          _buildTipItem('Ganti sarung bantal minimal 2x seminggu untuk menjaga kebersihan kulit.'),
        ],
      ),
    );
  }
}

// Tombol Jelajahi Produk Lainnya
class _ActionExploreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigasi ke halaman eksplor produk atau home
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimaryPink, 
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 5,
        ),
        icon: const Icon(Icons.arrow_forward_ios, size: 18), // Pindah ikon ke kanan
        label: const Text(
          'Jelajahi Produk Lainnya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}