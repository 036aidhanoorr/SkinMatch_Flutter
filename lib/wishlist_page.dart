// File: lib/wishlist_page.dart (VERSI RAPIH)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'recommendation.dart'; 
import 'app_state.dart'; // Menggunakan GlobalWishlist yang baru (ChangeNotifier)

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F); 
const Color _kLightPinkBackground = Color(0xFFFDEEF2); 
const Color _kHintGrey = Color(0xFF8D8D8D); 

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> { 

  String _formatRupiah(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(value);
  }

  void _onToggleWishlist(Product product) {
    GlobalWishlist().toggleWishlist(product); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          GlobalWishlist().isWishlisted(product.name) 
          ? '${product.name} ditambahkan kembali.' 
          : '${product.name} dihapus dari Wishlist.',
        ), 
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GlobalWishlist(), 
      builder: (context, child) {
        final wishlistProducts = GlobalWishlist().products; 
        final productCount = wishlistProducts.length;

        return Scaffold(
          backgroundColor: _kLightPinkBackground, 
          appBar: AppBar(
            title: const Text(
              'Wishlist Saya',
              style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold, 
                fontSize: 22,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    '$productCount produk tersimpan',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),

                  if (productCount == 0)
                    _buildEmptyWishlist()
                  else
                    _buildFilledWishlist(wishlistProducts),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyWishlist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _kLightPinkBackground,
              shape: BoxShape.circle,
              border: Border.all(color: _kPrimaryPink, width: 2),
            ),
            child: const Icon(
              Icons.favorite_outline,
              color: _kPrimaryPink,
              size: 55,
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Wishlist Kosong',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Kamu belum menyimpan produk apapun ke wishlist',
            style: TextStyle(fontSize: 15, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Tekan ikon hati pada produk yang kamu suka untuk menyimpannya di sini',
            style: TextStyle(fontSize: 14, color: _kHintGrey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFilledWishlist(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _kPrimaryPink,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 30),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Produk Favorit',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '${products.length} Produk',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        ...products.map((product) => Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _buildProductListItem(product),
        )).toList(),

        const SizedBox(height: 20),
        Center(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fungsi Bagikan Wishlist belum diimplementasi.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.share_outlined, color: _kPrimaryPink),
            label: const Text(
              'Bagikan Wishlist',
              style: TextStyle(color: _kPrimaryPink, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _kPrimaryPink),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductListItem(Product product) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
              image: product.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(product.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: product.imageUrl == null
                ? const Icon(Icons.shopping_bag_outlined, color: _kPrimaryPink)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.6',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _formatRupiah(product.price.toDouble()),
                  style: const TextStyle(fontSize: 15, color: _kPrimaryPink, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onToggleWishlist(product),
            child: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
