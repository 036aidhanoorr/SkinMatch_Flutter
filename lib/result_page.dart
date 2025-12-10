// File: lib/result_page.dart (OPTIMASI KERAPATAN VERTIKAL + WISHLIST)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'recommendation.dart'; // Pastikan Product Model ter-import
import 'app_state.dart'; // <<< PENTING: Import GlobalWishlist

// --- DEFINISI WARNA (Konsisten dengan InputPage) ---
const Color _kPrimaryPink = Color(0xFFFF699F);
const Color _kLightPinkBackground = Color(0xFFFDEEF2);
const Color _kLightBlueTips = Color(0xFFE3F2FD);

// Mengubah menjadi StatefulWidget
class ResultPage extends StatefulWidget {
  final List<Product> recommendations;
  final String skinType;
  final List<String> issues;
  final String budget;

  const ResultPage({
    super.key,
    required this.recommendations,
    required this.skinType,
    required this.issues,
    required this.budget,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

// =========================================================================
// PERUBAHAN UTAMA DIMULAI DI SINI
// =========================================================================

class _ResultPageState extends State<ResultPage> {
  // HAPUS: final Set<String> _wishlistProductNames = {};

  // Urutan Langkah berdasarkan prioritas (untuk tampilan yang konsisten)
  final List<String> _routineOrder = const [
    "Pembersih Wajah",
    "Toner",
    "Serum",
    "Pelembab",
    "Sunscreen",
  ];

  String _formatRupiah(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(value);
  }

  // Ganti fungsi toggle untuk menggunakan GlobalWishlist
  void _toggleWishlist(Product product) {
    // Memanggil logika global untuk menambah/menghapus produk
    final isAdded = GlobalWishlist().toggleWishlist(product); // <<< PENTING
    
    // setState lokal diperlukan untuk ListenableBuilder di halaman lain, 
    // tetapi ListenableBuilder di build() sudah menangani refresh ikon love di sini.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded 
          ? '${product.name} ditambahkan ke Wishlist!' 
          : '${product.name} dihapus dari Wishlist.',
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCost =
        widget.recommendations.fold(0.0, (sum, item) => sum + item.price);

    // Sortir rekomendasi berdasarkan urutan yang sudah ditentukan
    final sortedRecommendations = widget.recommendations.toList()
      ..sort((a, b) => _routineOrder
          .indexOf(a.category)
          .compareTo(_routineOrder.indexOf(b.category)));
    
    // Gunakan ListenableBuilder di sini
    return ListenableBuilder(
      listenable: GlobalWishlist(), // <<< PENTING: Mendengarkan perubahan
      builder: (context, child) {
        // Konten utama dipindahkan ke dalam builder
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              // Header
              _buildSliverHeader(),

              // Kartu Hasil Analisis (Atas)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: _buildAnalysisCard(totalCost),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Daftar Kartu Produk (Langkah Rutinitas)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                      child: _buildProductStepCard( // Panggil product card
                          sortedRecommendations[index], index + 1),
                    );
                  },
                  childCount: sortedRecommendations.length,
                ),
              ),

              // Tips Umum Skincare (Bawah)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 40),
                  child: _buildGeneralTipsCard(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET BUILDERS (Hanya perubahan kecil di _buildProductStepCard) ---

  Widget _buildSliverHeader() {
    // KODE SAMA
    return SliverAppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      pinned: false,
      elevation: 0,
      toolbarHeight: 60,
      titleSpacing: 25.0,
      title: const Text(
        'Rutinitas Skincare Untukmu',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
            child: Text(
              'Ikuti langkah-langkah ini untuk hasil maksimal',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(double totalCost) {
    // KODE SAMA
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kPrimaryPink,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _kPrimaryPink.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hasil Analisis',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildAnalysisDetail("Jenis Kulit: ${widget.skinType}"),
          _buildAnalysisDetail("Masalah: ${widget.issues.length} masalah terpilih"),
          _buildAnalysisDetail("Budget: ${widget.budget} per produk"),
          const Divider(color: Colors.white70, height: 25),
          const Text(
            'Total Investasi Rutinitas',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            _formatRupiah(totalCost),
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisDetail(String text) {
    // KODE SAMA
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0, top: 4.0),
            child:
                Icon(Icons.circle, size: 8, color: Colors.white70),
          ),
          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProductStepCard(Product product, int stepNumber) {
    // CEK STATUS DARI GLOBAL STATE
    final isWishlisted = GlobalWishlist().isWishlisted(product.name); // <<< PENTING
    
    return Card(
      elevation: 5,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nomor Langkah
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: _kPrimaryPink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        product.category,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          product.categoryDescription,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Routine Type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _kLightPinkBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.routineType,
                          style: const TextStyle(
                              fontSize: 12,
                              color: _kPrimaryPink,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 0, indent: 20, endIndent: 20),

          Padding(
            padding:
                const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Produk Rekomendasi:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            BorderRadius.circular(8),
                        image: product.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                    product.imageUrl!),
                                fit: BoxFit.cover)
                            : null,
                      ),
                      child: product.imageUrl == null
                          ? const Icon(Icons.image,
                              color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          Text(
                            product.name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _formatRupiah(
                                product.price.toDouble()),
                            style: const TextStyle(
                                fontSize: 15,
                                color: _kPrimaryPink,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Wishlist
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        // PANGGIL FUNGSI TOGGLE DENGAN OBJEK PRODUCT
                        onTap: () => _toggleWishlist(product), 
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? _kPrimaryPink : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (product.usageTips != null &&
              product.usageTips!.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kLightBlueTips,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: Color(0xFF1E88E5), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tips Penggunaan:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            product.usageTips!,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGeneralTipsCard() {
    // KODE SAMA
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kPrimaryPink.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips Umum Skincare',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _buildGeneralTipItem(
              "Konsistensi adalah kunci. Gunakan produk secara rutin minimal 28 hari untuk melihat hasil."),
          _buildGeneralTipItem(
              "Minum air putih minimal 8 gelas per hari untuk menjaga hidrasi kulit dari dalam."),
          _buildGeneralTipItem(
              "Hindari menyentuh wajah terlalu sering untuk mencegah transfer kotoran dan bakteri."),
        ],
      ),
    );
  }

  Widget _buildGeneralTipItem(String text) {
    // KODE SAMA
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 18, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}