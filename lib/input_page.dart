// File: lib/input_page.dart (PERBAIKAN: Hapus ikon centang di kanan atas)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skinmatch_flutter/recommendation.dart';
import 'package:skinmatch_flutter/result_page.dart';

// --- DEFINISI WARNA (Konsisten) ---
const Color _kPrimaryPink = Color(0xFFFF699F);
const Color _kLightPinkBackground = Color(0xFFFDEEF2);
const Color _kInputOutline = Color(0xFFE0E0E0);

// --- DEFINISI SLIDER BUDGET ---
const double _minBudget = 50000.0;
const double _maxBudget = 550000.0;
// Menggunakan 10000.0 sebagai interval terkecil untuk mendapatkan slider yang halus
final int _budgetDivisions = ((_maxBudget - _minBudget) / 10000.0).round(); 

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? _selectedSkinType;
  final List<String> _selectedSkinIssues = [];
  double _selectedBudget = 150000.0;

  final List<String> _skinTypes = [
    "Normal",
    "Berminyak",
    "Kering",
    "Kombinasi",
    "Sensitif"
  ];

  final List<String> _skinIssuesOptions = [
    "Jerawat",
    "Kusam",
    "Garis Halus & Kerutan",
    "Noda Hitam",
    "Pori-pori Besar",
    "Kulit Dehidrasi"
  ];

  String _formatRupiah(double value) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    if (value >= 1000000) {
      return 'Rp ${NumberFormat('0.#', 'id_ID').format(value / 1000000)}jt';
    } 
    
    String formatted = format.format(value).replaceAll(RegExp(r'\.00$'), '');
    return formatted
        .replaceAll(',', '#')
        .replaceAll('.', ',')
        .replaceAll('#', '.');
  }

  int _getCurrentStep() {
    if (_selectedSkinType == null) return 0;
    if (_selectedSkinIssues.isEmpty) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, _getCurrentStep()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 5.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSectionTitle("1. Jenis Kulit"),
                    const Text(
                      "Pilih jenis kulit yang paling sesuai dengan kondisi kulitmu",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _buildSkinTypeSelection(),
                    const SizedBox(height: 25),
                    _buildSectionTitle("2. Masalah Kulit"),
                    const Text(
                      "Pilih masalah kulit yang kamu alami (bisa lebih dari satu)",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _buildSkinIssueSelection(),
                    const SizedBox(height: 25),
                    _buildSectionTitle("3. Rentang Budget"),
                    const Text(
                      "Berapa budget yang kamu siapkan untuk skincare per produk?",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    _buildBudgetSlider(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
              child: _buildRecommendationButton(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildCustomHeader(BuildContext context, int currentStep) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                // Ikon Kembali di kiri atas
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              
              // >>> INI ADALAH BAGIAN YANG DIHAPUS (Icon centang di kanan atas)
              // Sebelumnya: const Icon(Icons.check_circle, color: _kPrimaryPink), 
              const SizedBox(width: 24), // Tambahkan SizedBox untuk menjaga alignment
              // <<< AKHIR BAGIAN YANG DIHAPUS
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Analisis Kulitmu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Jawab beberapa pertanyaan untuk mendapatkan rekomendasi terbaik',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(right: index < 2 ? 5 : 0),
                    color:
                        index <= currentStep ? _kPrimaryPink : _kInputOutline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSkinTypeSelection() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _skinTypes.map((type) {
        final isSelected = _selectedSkinType == type;
        return ChoiceChip(
          label: Text(type),
          selected: isSelected,
          selectedColor: _kLightPinkBackground,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: isSelected ? _kPrimaryPink : _kInputOutline,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          labelStyle: TextStyle(
            color: isSelected ? _kPrimaryPink : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          onSelected: (selected) {
            setState(() {
              _selectedSkinType = selected ? type : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSkinIssueSelection() {
    return Column(
      children: _skinIssuesOptions.map((issue) {
        final isSelected = _selectedSkinIssues.contains(issue);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? _kLightPinkBackground : Colors.white,
            borderRadius: BorderRadius.circular(15), 
            border: Border.all(
              color: isSelected ? _kPrimaryPink : _kInputOutline,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            minVerticalPadding: 8.0,
            dense: true,
            title: Text(
              issue,
              style: TextStyle(
                color: isSelected ? _kPrimaryPink : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: _kPrimaryPink, size: 24)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey[400], size: 24),
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSkinIssues.remove(issue);
                } else {
                  _selectedSkinIssues.add(issue);
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _kPrimaryPink,
            inactiveTrackColor: _kLightPinkBackground,
            thumbColor: _kPrimaryPink,
            overlayColor: _kPrimaryPink.withOpacity(0.2),
            trackHeight: 4.0,
            thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            showValueIndicator: ShowValueIndicator.never,
            tickMarkShape:
                const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
            activeTickMarkColor: _kPrimaryPink,
            inactiveTickMarkColor: Colors.white,
          ),
          child: Slider(
            value: _selectedBudget,
            min: _minBudget,
            max: _maxBudget,
            divisions: _budgetDivisions,
            onChanged: (value) {
              setState(() {
                _selectedBudget = (value / 10000).round() * 10000.0; 
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
          decoration: BoxDecoration(
            color: _kLightPinkBackground,
            borderRadius: BorderRadius.circular(15.0), 
            border: Border.all(
              color: _kPrimaryPink.withOpacity(0.5),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Budget Terpilih',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatRupiah(_selectedBudget),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _kPrimaryPink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationButton(BuildContext context) {
    bool isInputComplete =
        _selectedSkinType != null && _selectedSkinIssues.isNotEmpty;

    String buttonText;
    if (_selectedSkinType == null && _selectedSkinIssues.isEmpty) {
      buttonText = "Pilih jenis kulit dan minimal 1 masalah kulit";
    } else if (_selectedSkinType == null) {
      buttonText = "Pilih jenis kulitmu";
    } else if (_selectedSkinIssues.isEmpty) {
      buttonText = "Pilih minimal 1 masalah kulit";
    } else {
      buttonText = "Lihat Rekomendasi";
    }

    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isInputComplete
            ? () {
                final int budgetInt = _selectedBudget.toInt();
                final List<Product> recommendations = getRecommendations(
                  _selectedSkinType!,
                  _selectedSkinIssues,
                  budgetInt,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      recommendations: recommendations,
                      skinType: _selectedSkinType!,
                      issues: _selectedSkinIssues,
                      budget: _formatRupiah(_selectedBudget),
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimaryPink,
          disabledBackgroundColor: _kPrimaryPink.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), 
          ),
          elevation: 0,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}