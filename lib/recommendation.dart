// File: lib/recommendation.dart
// Versi final: dataset lebih lengkap + logic rekomendasi lebih pintar (scoring + rule-based decision tree)
// Penjelasan singkat:
// - Harga tetap sebagai filter (produk > maxBudget tidak masuk).
// - Setelah filter, setiap produk diberi skor berdasarkan kecocokan skin type, masalah, spesialisasi, dan harga.
// - Produk spesialis (fokus 1 issue) dan yang ditujukan spesifik untuk skin type tertentu diberi bonus.
// - Per kategori dasar (Pembersih Wajah, Toner, Pelembab, Sunscreen) dipilih 1 produk terbaik.
// - Serum ditambahkan kondisional bila ada masalah tertentu (jerawat, noda, anti-aging, dsb).

class Product {
  final String name;
  final String brand;
  final int price;
  final String category; // "Pembersih Wajah", "Toner", "Serum", "Pelembab", "Sunscreen"
  final String categoryDescription;
  final String routineType; // "Pagi & Malam", "Pagi", "Malam", dll.
  final List<String> suitableSkinTypes; // e.g. ['Normal','Kering','Berminyak','Sensitif','Semua']
  final List<String> targetIssues; // e.g. ['Jerawat','Kusam','Hidrasi','Pori-pori']
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

// -------------------------
// DATA PRODUK (DITINGKATKAN)
// -------------------------
// Category names use Indonesian labels to cocok dengan project-mu sebelumnya.
const List<Product> sampleProducts = [
  // --- Pembersih Wajah (Cleanser) ---
  Product(
    name: "Salicylic Acid Acne Cleanser (2% BHA)",
    brand: "Skintific",
    price: 79000,
    category: "Pembersih Wajah",
    categoryDescription: "Cleanser khusus acne dengan BHA untuk mengatasi jerawat meradang",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berminyak", "Berjerawat"],
    targetIssues: ["Jerawat", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Salicylic",
    usageTips: "Gunakan malam hari; jangan digunakan bersamaan dengan produk retinol aktif.",
  ),
  Product(
    name: "Low pH Good Morning Gel Cleanser",
    brand: "COSRX",
    price: 55000,
    category: "Pembersih Wajah",
    categoryDescription: "Cleanser pH rendah, lembut untuk hampir semua kulit",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal", "Kombinasi", "Berminyak"],
    targetIssues: ["Pori-pori", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=COSRX",
    usageTips: "Cocok dipakai pagi hari untuk membersihkan residu dan minyak berlebih.",
  ),
  Product(
    name: "Gentle Skin Cleanser",
    brand: "Cetaphil",
    price: 90000,
    category: "Pembersih Wajah",
    categoryDescription: "Pembersih non-irritating untuk kulit sensitif/kering",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Sensitif", "Normal"],
    targetIssues: ["Hidrasi", "Kemerahan"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Cetaphil",
    usageTips: "Gunakan dengan lembut, tidak perlu digosok keras.",
  ),
  Product(
    name: "Gokujyun Hydrating Face Wash",
    brand: "Hada Labo",
    price: 40000,
    category: "Pembersih Wajah",
    categoryDescription: "Pembersih hydrating untuk kulit kering/normal",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Normal"],
    targetIssues: ["Dehidrasi", "Kekeringan"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=HadaLabo",
    usageTips: "Ideal untuk kulit kering; gunakan air hangat suam-suam kuku.",
  ),
  Product(
    name: "Acne Gentle Wash",
    brand: "Wardah",
    price: 28000,
    category: "Pembersih Wajah",
    categoryDescription: "Pembersih terjangkau untuk jerawat ringan",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berjerawat", "Berminyak"],
    targetIssues: ["Jerawat Ringan"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Wardah",
    usageTips: "Cocok untuk pemakaian harian; jika kulit kering, gunakan lebih jarang.",
  ),
  Product(
    name: "Low pH Jelly Cleanser",
    brand: "Somethinc",
    price: 95000,
    category: "Pembersih Wajah",
    categoryDescription: "Cleanser jelly pH rendah, ringan dan ramah barrier",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Kusam", "Skin barrier"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Somethinc",
    usageTips: "Cocok untuk rutinitas pagi/malam; lembut pada kulit sensitif.",
  ),
  Product(
    name: "Tea Tree Skin Clearing Facial Wash",
    brand: "The Body Shop",
    price: 129000,
    category: "Pembersih Wajah",
    categoryDescription: "Cleanser berbasis tea tree untuk jerawat meradang",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berminyak", "Berjerawat"],
    targetIssues: ["Jerawat Meradang"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=TeaTree",
    usageTips: "Gunakan pada area yang berjerawat; hentikan jika iritasi muncul.",
  ),
  Product(
    name: "Natural Sublime Facial Cleanser",
    brand: "Avoskin",
    price: 95000,
    category: "Pembersih Wajah",
    categoryDescription: "Cleanser lembut untuk memperbaiki tekstur dan mencerahkan",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal", "Kombinasi"],
    targetIssues: ["Kusam", "Tekstur"],
    imageUrl: "https://via.placeholder.com/60/90c6f5/000000?text=Avoskin",
    usageTips: "Cocok untuk pengguna yang ingin brightening ringan.",
  ),

  // --- Toner ---
  Product(
    name: "Miraculous Refining Toner",
    brand: "Avoskin",
    price: 135000,
    category: "Toner",
    categoryDescription: "Toner eksfoliasi lembut untuk tekstur & noda",
    routineType: "Malam",
    suitableSkinTypes: ["Normal", "Berminyak"],
    targetIssues: ["Kusam", "Tekstur", "Noda Hitam"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=AvoskinToner",
    usageTips: "Gunakan malam 2-3x seminggu; hindari kombinasi dengan retinol kuat.",
  ),
  Product(
    name: "Centella Soothing Toner",
    brand: "NPure",
    price: 120000,
    category: "Toner",
    categoryDescription: "Toner calming dengan Centella untuk kulit sensitif",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Sensitif", "Berjerawat", "Normal"],
    targetIssues: ["Kemerahan", "Iritasi"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=NPure",
    usageTips: "Tepuk lembut pada kulit, cocok sebagai calming step.",
  ),
  Product(
    name: "Gokujyun Hydrating Toner",
    brand: "Hada Labo",
    price: 60000,
    category: "Toner",
    categoryDescription: "Toner hidrasi intens dengan Hyaluronic Acid",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Normal", "Kombinasi"],
    targetIssues: ["Hidrasi", "Kekeringan"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=HadaToner",
    usageTips: "Layer 2x jika kulit sangat kering.",
  ),
  Product(
    name: "5% Niacinamide Toner",
    brand: "Somethinc",
    price: 89000,
    category: "Toner",
    categoryDescription: "Toner mengandung niacinamide untuk pori & brightening",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Kusam", "Pori-pori"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=NiacToner",
    usageTips: "Aman dipakai tiap hari, cocok dipasangkan vitamin C pagi/siang.",
  ),
  Product(
    name: "Hyalucera Toner",
    brand: "The Originote",
    price: 29000,
    category: "Toner",
    categoryDescription: "Toner murah untuk hidrasi dan barrier",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Sensitif"],
    targetIssues: ["Barrier", "Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=OriginToner",
    usageTips: "Cocok untuk layering dan menenangkan kulit.",
  ),
  Product(
    name: "Glow Slick Toner",
    brand: "Mad For Makeup",
    price: 75000,
    category: "Toner",
    categoryDescription: "Toner brightening untuk kulit kusam",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal", "Kusam"],
    targetIssues: ["Brightening", "Kusam"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=GlowToner",
    usageTips: "Gunakan secara rutin untuk efek brightening bertahap.",
  ),
  Product(
    name: "Mugwort Anti Pores Toner",
    brand: "Skintific",
    price: 95000,
    category: "Toner",
    categoryDescription: "Toner untuk mengurangi pori dan minyak berlebih",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berminyak", "Kombinasi"],
    targetIssues: ["Pori-pori", "Minyak Berlebih"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=Mugwort",
    usageTips: "Baik digunakan untuk kontrol minyak di pagi hari.",
  ),
  Product(
    name: "White Secret Exfoliating Toner",
    brand: "Wardah",
    price: 110000,
    category: "Toner",
    categoryDescription: "Toner exfoliating untuk noda dan brightening",
    routineType: "Malam",
    suitableSkinTypes: ["Normal", "Kusam"],
    targetIssues: ["Noda Hitam", "Kusam"],
    imageUrl: "https://via.placeholder.com/60/a29bfe/000000?text=WardahToner",
    usageTips: "Gunakan malam dan jangan gabungkan dengan retinol/peel lain.",
  ),

  // --- Serum ---
  Product(
    name: "Niacinamide 10% Serum",
    brand: "Somethinc",
    price: 95000,
    category: "Serum",
    categoryDescription: "Serum niacinamide untuk pori, noda, dan brightening",
    routineType: "Malam",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Kusam", "Noda Hitam", "Pori-pori"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Niacinamide",
    usageTips: "Cocok dipakai tiap hari; gabungkan dengan hydrating serum.",
  ),
  Product(
    name: "5X Ceramide Barrier Repair Serum",
    brand: "Skintific",
    price: 109000,
    category: "Serum",
    categoryDescription: "Serum ceramide untuk memperbaiki barrier kulit",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Sensitif"],
    targetIssues: ["Barrier", "Dehidrasi"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Ceramide",
    usageTips: "Gunakan di pagi & malam untuk menguatkan skin barrier.",
  ),
  Product(
    name: "Your Skin Bae Retinol",
    brand: "Avoskin",
    price: 139000,
    category: "Serum",
    categoryDescription: "Retinol ringan untuk anti-aging dan tekstur",
    routineType: "Malam",
    suitableSkinTypes: ["Normal", "Kering"],
    targetIssues: ["Garis Halus", "Tekstur", "Anti-aging"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Retinol",
    usageTips: "Mulai 1-2x/minggu, tingkatkan frekuensi jika toleran.",
  ),
  Product(
    name: "Salicylic Acid 2%",
    brand: "The Ordinary",
    price: 130000,
    category: "Serum",
    categoryDescription: "Serum BHA untuk jerawat dan unclog pori",
    routineType: "Malam",
    suitableSkinTypes: ["Berminyak", "Berjerawat"],
    targetIssues: ["Jerawat", "Pori-pori"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=BHA",
    usageTips: "Spot treat atau gunakan di seluruh area berminyak; hindari iritasi.",
  ),
  Product(
    name: "Skin Barrier Serum",
    brand: "Dear Me Beauty",
    price: 120000,
    category: "Serum",
    categoryDescription: "Serum menenangkan untuk kulit sensitif dan rusak",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Sensitif"],
    targetIssues: ["Iritasi", "Barrier"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Barrier",
    usageTips: "Gunakan rutin untuk mempercepat pemulihan kulit.",
  ),
  Product(
    name: "Brightening Serum (Niacinamide + Collagen)",
    brand: "Whitelab",
    price: 70000,
    category: "Serum",
    categoryDescription: "Serum cerahkan kulit dan bantu menyamarkan noda",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Kusam", "Noda Hitam"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Brighten",
    usageTips: "Kombinasikan dengan sunscreen di pagi hari.",
  ),
  Product(
    name: "C Defense Serum",
    brand: "Wardah",
    price: 85000,
    category: "Serum",
    categoryDescription: "Vitamin C serum untuk brightening",
    routineType: "Pagi",
    suitableSkinTypes: ["Normal", "Kusam"],
    targetIssues: ["Brightening", "Noda Hitam"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=CSerum",
    usageTips: "Gunakan pagi hari dan selalu diikuti sunscreen.",
  ),
  Product(
    name: "Retinol Serum (Budget)",
    brand: "The Originote",
    price: 45000,
    category: "Serum",
    categoryDescription: "Retinol ringan untuk anti-aging pemula",
    routineType: "Malam",
    suitableSkinTypes: ["Normal"],
    targetIssues: ["Anti-aging"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Reti",
    usageTips: "Mulai perlahan, pakai 1x/minggu terlebih dulu.",
  ),
  Product(
    name: "Licorice Brightening Serum",
    brand: "SOMETHINC",
    price: 115000,
    category: "Serum",
    categoryDescription: "Serum untuk noda hitam & brightening",
    routineType: "Malam",
    suitableSkinTypes: ["Normal", "Kusam"],
    targetIssues: ["Noda Hitam", "Kusam"],
    imageUrl: "https://via.placeholder.com/60/ffeaa7/000000?text=Licorice",
    usageTips: "Cocok untuk penggunaan jangka panjang untuk meratakan warna kulit.",
  ),

  // --- Pelembab (Moisturizer) ---
  Product(
    name: "5X Ceramide Moisturizer",
    brand: "Skintific",
    price: 139000,
    category: "Pelembab",
    categoryDescription: "Moisturizer kaya ceramide untuk perbaikan barrier",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Barrier", "Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=CeraMoist",
    usageTips: "Gunakan pada wajah yang masih lembap setelah serum.",
  ),
  Product(
    name: "Moisturizing Cream",
    brand: "Cetaphil",
    price: 145000,
    category: "Pelembab",
    categoryDescription: "Cream melembabkan untuk kulit sangat kering/sensitif",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kering", "Sensitif"],
    targetIssues: ["Dehidrasi", "Kemerahan"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=CetaphilMoist",
    usageTips: "Cocok digunakan pada malam hari untuk hidrasi intens.",
  ),
  Product(
    name: "Gokujyun Light Cream",
    brand: "Hada Labo",
    price: 65000,
    category: "Pelembab",
    categoryDescription: "Cream ringan untuk kulit kombinasi",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Kombinasi"],
    targetIssues: ["Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=HadaMoist",
    usageTips: "Ringan, cocok untuk base makeup.",
  ),
  Product(
    name: "Hyalucera Moisturizer",
    brand: "The Originote",
    price: 35000,
    category: "Pelembab",
    categoryDescription: "Moisturizer murah untuk hidrasi dan barrier",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Sensitif"],
    targetIssues: ["Barrier", "Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=OriginMoist",
    usageTips: "Cocok untuk kulit sensitif yang mudah iritasi.",
  ),
  Product(
    name: "Gel Moisturizer (Oil Free)",
    brand: "Somethinc",
    price: 110000,
    category: "Pelembab",
    categoryDescription: "Gel moisturizer non-comedogenic untuk kulit berminyak",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Berminyak"],
    targetIssues: ["Minyak Berlebih", "Pori-pori"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=GelMoist",
    usageTips: "Gunakan tipis-tipis pada pagi hari sebelum sunscreen.",
  ),
  Product(
    name: "Aloe Hydramild Moisturizer",
    brand: "Wardah",
    price: 25000,
    category: "Pelembab",
    categoryDescription: "Moisturizer sederhana dan terjangkau untuk hidrasi ringan",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal"],
    targetIssues: ["Hidrasi"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=WardahMoist",
    usageTips: "Murah meriah, cocok untuk pemakaian sehari-hari.",
  ),
  Product(
    name: "Tensile Lifting Cream",
    brand: "Avoskin",
    price: 180000,
    category: "Pelembab",
    categoryDescription: "Moisturizer anti-aging untuk kulit kering/normal",
    routineType: "Pagi & Malam",
    suitableSkinTypes: ["Normal", "Kering"],
    targetIssues: ["Anti-aging", "Elastisitas"],
    imageUrl: "https://via.placeholder.com/60/55efc4/000000?text=AvoskinMoist",
    usageTips: "Baik dipakai malam hari untuk perawatan anti-aging.",
  ),

  // --- Sunscreen ---
  Product(
    name: "UV Aqua Rich SPF 50+",
    brand: "Biore",
    price: 55000,
    category: "Sunscreen",
    categoryDescription: "Sunscreen tekstur ringan, cocok untuk daily use",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Perlindungan UV"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=BioreSPF",
    usageTips: "Gunakan 2 jari penuh dan reapply tiap 2-3 jam jika terpapar matahari.",
  ),
  Product(
    name: "Gel Sunscreen SPF 50",
    brand: "Dear Me Beauty",
    price: 109000,
    category: "Sunscreen",
    categoryDescription: "Sunscreen gel ramah sensitif, minim whitecast",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Semua Jenis Kulit", "Sensitif"],
    targetIssues: ["Perlindungan UV"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=DearMeSPF",
    usageTips: "Cocok untuk kulit sensitif, reapply bila perlu.",
  ),
  Product(
    name: "Ultra Light Sun Serum SPF 50",
    brand: "Skintific",
    price: 99000,
    category: "Sunscreen",
    categoryDescription: "Sunscreen tekstur serum, finish matte",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Berminyak"],
    targetIssues: ["Perlindungan UV", "Kontrol Minyak"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=SunSerum",
    usageTips: "Cocok untuk kulit berminyak; gunakan sebelum makeup.",
  ),
  Product(
    name: "Moisture Milk SPF 50",
    brand: "Skin Aqua",
    price: 60000,
    category: "Sunscreen",
    categoryDescription: "Sunscreen cair untuk kulit normal/kering",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Normal", "Kering"],
    targetIssues: ["Perlindungan UV"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=SkinAqua",
    usageTips: "Tekstur ringan, cocok dipakai sehari-hari.",
  ),
  Product(
    name: "UV Shield Gel SPF 30",
    brand: "Wardah",
    price: 25000,
    category: "Sunscreen",
    categoryDescription: "Sunscreen ekonomis untuk proteksi dasar",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Normal"],
    targetIssues: ["Perlindungan UV"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=WardahSPF",
    usageTips: "Bagus sebagai opsi murah, namun SPF lebih rendah (30).",
  ),
  Product(
    name: "Copy Paste Sunstick SPF 50",
    brand: "Somethinc",
    price: 89000,
    category: "Sunscreen",
    categoryDescription: "Sunstick praktis untuk reapply sepanjang hari",
    routineType: "Pagi (Wajib)",
    suitableSkinTypes: ["Semua Jenis Kulit"],
    targetIssues: ["Perlindungan UV", "Reapply"],
    imageUrl: "https://via.placeholder.com/60/ff7675/000000?text=Sunstick",
    usageTips: "Praktis untuk bawa bepergian; reapply setelah keringat/aktivitas.",
  ),
];

// -------------------------
// LOGIKA REKOMENDASI (Scoring + Decision Rules)
// -------------------------

List<Product> getRecommendations(String skinType, List<String> issues, int maxBudget) {
  // Normalisasi input: lowercased for comparisons
  final String skinTypeLc = skinType.trim().toLowerCase();
  final List<String> issuesLc = issues.map((s) => s.trim().toLowerCase()).toList();

  // Helper: cek apakah product cocok dengan skin type (case-insensitive)
  bool matchesSkin(Product p) {
    return p.suitableSkinTypes.map((s) => s.toLowerCase()).contains(skinTypeLc) ||
        p.suitableSkinTypes.map((s) => s.toLowerCase()).contains('semua') ||
        p.suitableSkinTypes.map((s) => s.toLowerCase()).contains('semua jenis kulit');
  }

  // Helper: cek apakah product menargetkan salah satu issue user
  bool targetsIssue(Product p) {
    final Set<String> productIssues = p.targetIssues.map((s) => s.toLowerCase()).toSet();
    for (var i in issuesLc) {
      if (productIssues.contains(i)) return true;
    }
    return false;
  }

  // Hitung skor produk berdasarkan beberapa faktor
  // Bobot (bisa di-tune):
  // - match skin type: +3
  // - match issue: +4 per issue matched (but cap to avoid huge bias)
  // - product spesialis (hanya 1 targetIssue): +2
  // - product khusus untuk skin type (tidak 'Semua'): +1
  // - harga lebih murah dibanding maxBudget (lebih hemat): +1 (jika price <= maxBudget/2 -> +2)
  double scoreProduct(Product p) {
    double score = 0;

    // skin match
    if (matchesSkin(p)) score += 3;

    // issue matches: +2 per matched issue (bounded)
    final Set<String> productIssues = p.targetIssues.map((s) => s.toLowerCase()).toSet();
    int matchedIssues = 0;
    for (var userIssue in issuesLc) {
      if (productIssues.contains(userIssue)) matchedIssues++;
    }
    // cap matched issues contribution to 2 (so max +4 here)
    score += 2 * (matchedIssues.clamp(0, 2));

    // spesialis produk: jika hanya 1 targetIssue -> lebih spesifik
    if (p.targetIssues.length == 1) score += 2;

    // khusus skin type (misal 'Kering' bukan 'Semua')
    final List<String> loweredTypes = p.suitableSkinTypes.map((s) => s.toLowerCase()).toList();
    if (!loweredTypes.contains('semua') && !loweredTypes.contains('semua jenis kulit')) {
      // jika produk menyebutkan skin types spesifik dan salah satunya cocok -> +1
      if (loweredTypes.contains(skinTypeLc)) score += 1;
    }

    // price bonus: produk jauh lebih murah dari maxBudget dapat sedikit bonus
    if (p.price <= maxBudget) {
      if (p.price <= (maxBudget / 2)) {
        score += 2; // sangat hemat
      } else {
        score += 1; // sedikit lebih murah
      }
    }

    return score;
  }

  // Fungsi cari produk terbaik per kategori (satu produk)
  Product? findBestProduct(String category) {
    // Filter awal berdasarkan kategori & budget (produk di atas budget tidak masuk)
    List<Product> candidates = sampleProducts
        .where((p) => p.category == category && p.price <= maxBudget)
        .toList();

    if (candidates.isEmpty) return null;

    // Hitung skor untuk setiap kandidat
    candidates.sort((a, b) {
      final double sa = scoreProduct(a);
      final double sb = scoreProduct(b);

      // Urutkan berdasarkan skor desc
      if (sa != sb) return sb.compareTo(sa);

      // tie-breaker 1: pilih produk dengan lebih banyak kecocokan issue (prioritas relevansi)
      final int aMatched = a.targetIssues.map((s) => s.toLowerCase()).toSet()
          .intersection(issues.map((s) => s.toLowerCase()).toSet()).length;
      final int bMatched = b.targetIssues.map((s) => s.toLowerCase()).toSet()
          .intersection(issues.map((s) => s.toLowerCase()).toSet()).length;
      if (aMatched != bMatched) return bMatched.compareTo(aMatched);

      // tie-breaker 2: harga lebih murah menang
      if (a.price != b.price) return a.price.compareTo(b.price);

      // terakhir: urut alfabet brand
      return a.brand.compareTo(b.brand);
    });

    return candidates.first;
  }

  List<Product> recommended = [];

  // Kategori utama
  const List<String> routineCategories = [
    "Pembersih Wajah",
    "Toner",
    "Pelembab",
    "Sunscreen",
  ];

  for (var category in routineCategories) {
    final Product? best = findBestProduct(category);
    if (best != null) recommended.add(best);
  }

  // Kondisional: serum untuk masalah tertentu
  // Jika user punya masalah yang biasanya butuh serum (jerawat, noda, anti-aging, barrier, hidrasi)
  final List<String> serumTriggerIssues = [
    "jerawat",
    "noda hitam",
    "noda",
    "kusam",
    "garis halus",
    "anti-aging",
    "barrier",
    "hidrasi",
  ];

  bool includeSerum = false;
  for (var i in issuesLc) {
    if (serumTriggerIssues.contains(i)) {
      includeSerum = true;
      break;
    }
  }

  if (includeSerum) {
    final Product? bestSerum = findBestProduct("Serum");
    if (bestSerum != null) recommended.add(bestSerum);
  }

  return recommended;
}
