// File: lib/recommendation.dart

// --- DEFINISI MODEL DATA ---
class Product {
  final String name;
  final String brand;
  final int price;
  final String category; // Cleanser, Toner, Serum, Moisturizer, Sunscreen
  final String categoryDescription;
  final String routineType; // Pagi & Malam, Pagi, Malam
  final List<String> suitableSkinTypes; // 'Normal', 'Kering', 'Berminyak', 'Sensitif'
  final List<String> targetIssues; // 'Jerawat', 'Kusam', 'Hidrasi', 'Pori-pori', dll.
  final String? imageUrl;
  final String? usageTips;

  const Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.categoryDescription,
    required this.routineType,
    required this.suitableSkinTypes,
    required this.targetIssues,
    this.imageUrl,
    this.usageTips,
  });
}

// --- DUMMY DATA PRODUK (PUBLIC) ---
// Diubah menjadi 'sampleProducts' agar bisa diakses di ExplorePage
const List<Product> sampleProducts = [
  // Cleansers
  Product(
    name: "Acne Care Face Wash",
    brand: "Skintific",
    price: 75000,
    category: "Pembersih Wajah",
    categoryDescription: "Pembersih dengan pH seimbang untuk kulit berjerawat",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berminyak", "Kombinasi", "Berjerawat"],
    targetIssues: ["Jerawat", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Cleanser",
    usageTips: "Gunakan air suam-suam kuku dan pijat lembut, bilas hingga bersih. Fokus pada area T-zone.",
  ),
  Product(
    name: "Gentle Cleanser",
    brand: "Cetaphil",
    price: 85000,
    category: "Pembersih Wajah",
    categoryDescription: "Pembersih ringan tanpa busa untuk kulit sensitif/kering",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Sensitif", "Normal"],
    targetIssues: ["Hidrasi", "Kemerahan"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Cleanser",
    usageTips: "Pijat perlahan pada kulit yang sudah dibasahi. Hindari menggosok, cukup usap lembut.",
  ),
  Product(
    name: "Low pH Gel Cleanser",
    brand: "Cosrx",
    price: 55000,
    category: "Pembersih Wajah",
    categoryDescription: "Pembersih gel dengan pH rendah, cocok untuk semua jenis kulit",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal", "Kombinasi", "Berminyak"],
    targetIssues: ["Pori-pori", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Cleanser",
    usageTips: "Ideal digunakan saat rutinitas pagi untuk membersihkan residu tidur.",
  ),

  // Toners
  Product(
    name: "Brightening Toner",
    brand: "Avoskin",
    price: 135000,
    category: "Toner",
    categoryDescription: "Toner eksfoliasi lembut dengan PHA dan Niacinamide",
    routineType: "Malam",
    suitableSkinTypes: ["Normal", "Kombinasi", "Kusam"],
    targetIssues: ["Kusam", "Noda Hitam"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=Toner",
    usageTips: "Gunakan hanya di malam hari 2-3 kali seminggu. Jangan digunakan bersamaan dengan serum Retinol.",
  ),
  Product(
    name: "Soothing Toner",
    brand: "NPure",
    price: 120000,
    category: "Toner",
    categoryDescription: "Toner hidrasi dan penenang dengan Centella Asiatica",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Sensitif", "Berjerawat", "Normal"],
    targetIssues: ["Kemerahan", "Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=Toner",
    usageTips: "Gunakan dengan menepuk-nepuk menggunakan tangan bersih. Baik untuk kompres wajah saat iritasi.",
  ),
  Product(
    name: "Hydrating Essence Toner",
    brand: "Hada Labo",
    price: 60000,
    category: "Toner",
    categoryDescription: "Toner yang sangat melembabkan dengan Hyaluronic Acid",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Normal", "Kombinasi"],
    targetIssues: ["Hidrasi", "Kekeringan"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=Toner",
    usageTips: "Aplikasikan 2 layer jika kulit terasa sangat kering.",
  ),

  // Serums
  Product(
    name: "Acne Spot Treatment Serum",
    brand: "Skintific",
    price: 89000,
    category: "Serum",
    categoryDescription: "Merawat dan mengurangi jerawat dan bekasnya",
    routineType: "Malam (Spot/Wajah)",
    suitableSkinTypes: ["Berminyak", "Berjerawat"],
    targetIssues: ["Jerawat", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Serum",
    usageTips: "Gunakan hanya di area berjerawat atau seluruh wajah (jika tidak sedang hamil/menyusui).",
  ),
  Product(
    name: "Niacinamide Serum",
    brand: "Somethinc",
    price: 95000,
    category: "Serum",
    categoryDescription: "Mencerahkan, mengecilkan pori, dan memperkuat skin barrier",
    routineType: "Malam",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Kusam", "Noda Hitam", "Pori-pori"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Serum",
    usageTips: "Cocok dipasangkan dengan semua produk lain, aman digunakan setiap hari.",
  ),
  Product(
    name: "Retinol Anti-Aging Serum",
    brand: "Glow Up",
    price: 155000,
    category: "Serum",
    categoryDescription: "Serum untuk anti-penuaan dini dan perbaikan tekstur",
    routineType: "Malam",
    suitableSkinTypes: ["Normal", "Kering"],
    targetIssues: ["Garis Halus", "Anti-aging"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Serum",
    usageTips: "Mulai dengan 1-2 kali seminggu. Wajib diikuti dengan penggunaan Sunscreen di pagi hari.",
  ),
  
  // Moisturizers
  Product(
    name: "Hydrating Moisturizer",
    brand: "Cetaphil",
    price: 145000,
    category: "Pelembab",
    categoryDescription: "Pelembab bertekstur cream, sangat melembabkan",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Sensitif"],
    targetIssues: ["Kekeringan", "Kemerahan", "Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=Moist",
    usageTips: "Gunakan pada kulit yang masih sedikit lembab setelah serum untuk mengunci hidrasi.",
  ),
  Product(
    name: "Ceramide Gel Moisturizer",
    brand: "Skintific",
    price: 139000,
    category: "Pelembab",
    categoryDescription: "Pelembab bertekstur gel ringan, cocok untuk kulit berminyak",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berminyak", "Kombinasi", "Berjerawat"],
    targetIssues: ["Skin Barrier", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=Moist",
    usageTips: "Gunakan tipis-tipis di pagi hari sebelum sunscreen. Jangan lupakan area leher.",
  ),
  Product(
    name: "Daily Moisturizer",
    brand: "Wardah",
    price: 35000,
    category: "Pelembab",
    categoryDescription: "Pelembab harian yang ringan dan terjangkau",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal", "Kombinasi"],
    targetIssues: ["Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=Moist",
    usageTips: "Bisa digunakan sebagai base makeup. Ulangi di malam hari.",
  ),
  
  // Sunscreens
  Product(
    name: "Sunscreen SPF 50 PA++++",
    brand: "Biore",
    price: 55000,
    category: "Sunscreen",
    categoryDescription: "Chemical Sunscreen bertekstur ringan seperti air",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Perlindungan UV"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=SPF",
    usageTips: "Gunakan sebanyak dua jari penuh dan re-apply setiap 3-4 jam jika di luar ruangan.",
  ),
  Product(
    name: "Hybrid Sunscreen Gel",
    brand: "Dear Me Beauty",
    price: 109000,
    category: "Sunscreen",
    categoryDescription: "Hybrid Sunscreen dengan tekstur gel, minim whitecast",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Semua Jenis Kulit", "Sensitif"],
    targetIssues: ["Perlindungan UV"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=SPF",
    usageTips: "Wajib digunakan walau di dalam ruangan, terutama jika dekat jendela.",
  ),
];


// --- LOGIKA REKOMENDASI (Tidak diubah, hanya memastikan menggunakan 'sampleProducts') ---
List<Product> getRecommendations(
    String skinType, List<String> issues, int maxBudget) {
  
  List<Product> recommended = [];
  
  const List<String> routineCategories = [
    "Pembersih Wajah", 
    "Toner", 
    "Pelembab", 
    "Sunscreen"
  ];
  
  bool includeSerum = issues.any((issue) => 
      issue == "Jerawat" || issue == "Noda Hitam" || issue == "Garis Halus");

  for (var category in routineCategories) {
    // Filter semua kandidat produk berdasarkan Budget dan Kategori
    List<Product> candidates = sampleProducts // Menggunakan sampleProducts
        .where((p) => p.category == category && p.price <= maxBudget)
        .toList();
    
    // ... (Logika sorting tetap sama) ...

    if (candidates.isNotEmpty) {
      candidates.sort((a, b) {
        bool aMatchesSkin = a.suitableSkinTypes.contains(skinType);
        bool bMatchesSkin = b.suitableSkinTypes.contains(skinType);
        
        if (aMatchesSkin && !bMatchesSkin) return -1;
        if (!aMatchesSkin && bMatchesSkin) return 1;
        
        bool aTargetsIssue = a.targetIssues.any((issue) => issues.contains(issue));
        bool bTargetsIssue = b.targetIssues.any((issue) => issues.contains(issue));
        
        if (aTargetsIssue && !bTargetsIssue) return -1;
        if (!aTargetsIssue && bTargetsIssue) return 1;

        return 0; 
      });

      recommended.add(candidates.first);
    }
  }

  if (includeSerum) {
    List<Product> serumCandidates = sampleProducts // Menggunakan sampleProducts
        .where((p) => p.category == 'Serum' && p.price <= maxBudget)
        .toList();

    if (serumCandidates.isNotEmpty) {
        serumCandidates.sort((a, b) {
            bool aTargetsIssue = a.targetIssues.any((issue) => issues.contains(issue));
            bool bTargetsIssue = b.targetIssues.any((issue) => issues.contains(issue));
            
            if (aTargetsIssue && !bTargetsIssue) return -1;
            if (!aTargetsIssue && bTargetsIssue) return 1;
            return 0;
        });
        recommended.add(serumCandidates.first);
    }
  }

  return recommended;
}