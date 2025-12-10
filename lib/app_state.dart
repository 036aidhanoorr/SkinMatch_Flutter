// File: lib/app_state.dart

import 'package:flutter/foundation.dart'; // Import untuk ChangeNotifier
import 'recommendation.dart'; // Import Model Product

// GlobalWishlist adalah Singleton dan ChangeNotifier
class GlobalWishlist extends ChangeNotifier {
  // Singleton pattern: instance tunggal
  static final GlobalWishlist _instance = GlobalWishlist._internal();
  factory GlobalWishlist() => _instance;
  GlobalWishlist._internal();

  // Data penyimpanan
  final Map<String, Product> _wishlist = {};

  // Getter: Mengambil data produk
  List<Product> get products => _wishlist.values.toList();
  int get productCount => _wishlist.length;

  // Toggle: Tambah/Hapus produk dan MEMBERITAHU LISTENER
  bool toggleWishlist(Product product) {
    bool isAdded;
    if (_wishlist.containsKey(product.name)) {
      _wishlist.remove(product.name);
      isAdded = false;
    } else {
      _wishlist[product.name] = product;
      isAdded = true;
    }
    
    // PENTING: Memberi tahu WishlistPage untuk rebuild
    notifyListeners(); 
    return isAdded;
  }

  // Cek status
  bool isWishlisted(String productName) {
    return _wishlist.containsKey(productName);
  }
}