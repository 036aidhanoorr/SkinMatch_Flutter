// File: lib/explore.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'recommendation.dart'; // Import Product Model dan sampleProducts
import 'app_state.dart'; // Import GlobalWishlist (sebagai ChangeNotifier)

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F);
const Color _kLightPinkBackground = Color(0xFFFDEEF2);
const Color _kHintGrey = Color(0xFF8D8D8D);

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // BARIS PERBAIKAN ERROR: Definisikan data sumber
  late final List<Product> _allProducts;
  List<Product> _filteredProducts = [];
  
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  
  final List<String> _productCategories = const [
    'Semua', 
    'Pembersih Wajah', 
    'Toner', 
    'Serum', 
    'Pelembab', 
    'Sunscreen'
  ];

  @override
  void initState() {
    super.initState();
    // PERBAIKAN: Inisialisasi _allProducts dengan variabel publik 'sampleProducts'
    _allProducts = sampleProducts; 
    _filterProducts();
  }

  String _formatRupiah(double value) {
    // Pastikan nilai diubah ke double sebelum diformat
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(value);
  }

  void _filterProducts() {
    Iterable<Product> products = _allProducts;

    // 1. Filter berdasarkan Kategori
    if (_selectedCategory != 'Semua') {
      products = products.where((product) => product.category == _selectedCategory);
    }

    // 2. Filter berdasarkan Pencarian
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase()));
    }

    setState(() {
      _filteredProducts = products.toList();
    });
  }

  void _toggleWishlist(Product product) {
    // Memanggil logika global menggunakan instance GlobalWishlist()
    final isAdded = GlobalWishlist().toggleWishlist(product);
    
    // setState di sini hanya untuk me-refresh ikon hati di ExplorePage itu sendiri
    setState(() {}); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded 
          ? '${product.name} ditambahkan ke Wishlist!' 
          : '${product.name} dihapus dari Wishlist.',
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Jelajahi Produk',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 22
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Temukan produk skincare terbaik untukmu',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildSearchBar(),
          ),

          // Filter Chips (Kategori dan Filter Icon)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: _buildCategoryChips(),
          ),

          // Product Grid
          Expanded(
            // Gunakan ListenableBuilder untuk me-refresh ikon Wishlist jika di-toggle di halaman lain
            child: ListenableBuilder(
              listenable: GlobalWishlist(), 
              builder: (context, child) {
                if (_filteredProducts.isEmpty) {
                  return _buildEmptyResult();
                }

                return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 80.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_filteredProducts[index]);
                    },
                  );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        _searchQuery = value;
        _filterProducts();
      },
      decoration: InputDecoration(
        hintText: 'Cari produk atau brand...',
        hintStyle: const TextStyle(color: _kHintGrey),
        prefixIcon: const Icon(Icons.search, color: _kHintGrey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Row(
      children: [
        // Filter Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _kLightPinkBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.filter_list, color: _kPrimaryPink),
        ),
        const SizedBox(width: 10),
        
        // Category Chips
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _productCategories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: _kPrimaryPink,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: isSelected
                          ? BorderSide.none
                          : BorderSide(color: Colors.grey.shade300),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _filterProducts();
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    // Cek status Wishlist dari Global State
    // PENTING: Menggunakan instance GlobalWishlist()
    final isWishlisted = GlobalWishlist().isWishlisted(product.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Gambar Produk
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
                image: product.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imageUrl == null
                  ? const Center(child: Icon(Icons.shopping_bag_outlined, color: _kPrimaryPink))
                  : null,
            ),

            // Tombol Wishlist
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _toggleWishlist(product), // Memanggil fungsi toggle Wishlist
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWishlisted ? _kPrimaryPink : _kHintGrey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          product.brand,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: const [
            Icon(Icons.star, color: Colors.amber, size: 16),
            SizedBox(width: 4),
            Text(
              '4.8',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          _formatRupiah(product.price.toDouble()),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kPrimaryPink),
        ),
      ],
    );
  }

  Widget _buildEmptyResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.search_off,
            color: _kHintGrey,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'Produk Tidak Ditemukan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _kHintGrey,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Coba ganti kategori atau kata kunci pencarian Anda.',
              style: TextStyle(fontSize: 15, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}