// Model Data Produk
class Product {
  final String name;
  final String category; 
  final double price;
  final List<String> suitableSkinTypes; 
  final List<String> targetConcerns; 

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.suitableSkinTypes,
    required this.targetConcerns,
  });
}

// Data Dummy (Contoh)
final List<Product> productDatabase = [
  Product(
    name: 'Gentle Cleanser',
    category: 'Cleanser',
    price: 120000,
    suitableSkinTypes: ['Dry', 'Normal', 'Sensitive'],
    targetConcerns: ['Dullness'],
  ),
  Product(
    name: 'Acne Serum SA',
    category: 'Serum',
    price: 155000,
    suitableSkinTypes: ['Oily', 'Combination'],
    targetConcerns: ['Acne', 'Large Pores'],
  ),
  Product(
    name: 'Brightening Serum',
    category: 'Serum',
    price: 170000,
    suitableSkinTypes: ['All'],
    targetConcerns: ['Dullness', 'Uneven Tone'],
  ),
  Product(
    name: 'Sunscreen SPF 50',
    category: 'Sunscreen',
    price: 105000,
    suitableSkinTypes: ['All'],
    targetConcerns: ['Sun Protection'],
  ),
  Product(
    name: 'Barrier Moisturizer',
    category: 'Moisturizer',
    price: 95000,
    suitableSkinTypes: ['Dry', 'Sensitive'],
    targetConcerns: ['Redness', 'Dehydration'],
  ),
  Product(
    name: 'Hydrating Moisturizer',
    category: 'Moisturizer',
    price: 110000,
    suitableSkinTypes: ['Oily', 'Combination', 'Normal'],
    targetConcerns: ['Dehydration'],
  ),
];

// Logika Rekomendasi (Decision Tree)
class RecommenderService {
  List<Product> getRecommendation({
    required String skinType,
    required List<String> concerns,
    required double maxPrice,
  }) {
    List<Product> recommendedProducts = [];

    // Filter produk yang cocok dengan tipe kulit dan harga
    final filteredProducts = productDatabase.where((product) {
      final isSuitable = product.suitableSkinTypes.contains('All') || 
                         product.suitableSkinTypes.contains(skinType);
      final isAffordable = product.price <= maxPrice;
      return isSuitable && isAffordable;
    }).toList();

    // 1. Produk Wajib (Cleanser, Moisturizer, Sunscreen)
    // Ambil produk terbaik yang cocok, prioritizing filter.
    
    // Cleanser
    final cleanser = filteredProducts.firstWhere(
      (p) => p.category == 'Cleanser', 
      orElse: () => filteredProducts.firstWhere((p) => p.category == 'Cleanser'),
    );
    recommendedProducts.add(cleanser);

    // Sunscreen
    final sunscreen = filteredProducts.firstWhere(
      (p) => p.category == 'Sunscreen', 
      orElse: () => filteredProducts.firstWhere((p) => p.category == 'Sunscreen'),
    );
    recommendedProducts.add(sunscreen);

    // Moisturizer (Coba cari yang paling spesifik berdasarkan tipe kulit)
     final moisturizer = filteredProducts.firstWhere(
      (p) => p.category == 'Moisturizer' && p.suitableSkinTypes.contains(skinType), 
      orElse: () => filteredProducts.firstWhere((p) => p.category == 'Moisturizer')
    );
    recommendedProducts.add(moisturizer);

    // 2. Serum (Berdasarkan Masalah Kulit)
    for (var concern in concerns) {
      final serum = filteredProducts.firstWhere(
        (p) => p.category == 'Serum' && p.targetConcerns.contains(concern),
        // Fallback Product untuk menghindari error jika tidak ditemukan
        orElse: () => Product(name: 'NONE', category: 'Serum', price: 0, suitableSkinTypes: [], targetConcerns: []), 
      );
      if (serum.price != 0) {
          recommendedProducts.add(serum);
      }
    }
    
    // Hapus duplikasi dan kembalikan
    return recommendedProducts.toSet().toList();
  }
}