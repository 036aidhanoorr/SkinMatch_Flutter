import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Perlu ditambahkan di pubspec.yaml
import 'package:skinmatch_flutter/result_page.dart'; // Import halaman hasil
import 'package:skinmatch_flutter/service.dart'; // Import model dan logika

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? _selectedSkinType;
  List<String> _selectedConcerns = [];
  double _priceRange = 100000; 

  final List<String> skinTypes = ['Normal', 'Dry', 'Oily', 'Combination', 'Sensitive'];
  final List<String> skinConcerns = ['Acne', 'Dullness', 'Fine Lines', 'Redness', 'Large Pores', 'Dehydration', 'Uneven Tone'];

  void _submit() {
    if (_selectedSkinType != null && _selectedConcerns.isNotEmpty) {
      final results = RecommenderService().getRecommendation(
        skinType: _selectedSkinType!,
        concerns: _selectedConcerns,
        maxPrice: _priceRange,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            recommendations: results,
            skinType: _selectedSkinType!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- UI sesuai Figma ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temukan Skincare Idealmu'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Jenis Kulit
            _buildSectionTitle('1. Jenis Kulit Anda'),
            Wrap(
              spacing: 10.0,
              children: skinTypes.map((type) => ChoiceChip(
                label: Text(type),
                selected: _selectedSkinType == type,
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.5),
                onSelected: (selected) => setState(() => _selectedSkinType = selected ? type : null),
              )).toList(),
            ),
            const SizedBox(height: 30),

            // 2. Masalah Kulit
            _buildSectionTitle('2. Masalah Kulit Utama (Max 3)'),
            Wrap(
              spacing: 10.0,
              runSpacing: 5.0,
              children: skinConcerns.map((concern) => FilterChip(
                label: Text(concern),
                selected: _selectedConcerns.contains(concern),
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.5),
                onSelected: (selected) {
                  setState(() {
                    if (selected && _selectedConcerns.length < 3) {
                      _selectedConcerns.add(concern);
                    } else if (!selected) {
                      _selectedConcerns.remove(concern);
                    }
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 30),

            // 3. Range Harga
            _buildSectionTitle('3. Range Harga Maksimal'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Maksimum: ${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(_priceRange)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              value: _priceRange,
              min: 50000,
              max: 500000,
              divisions: 9,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (double value) => setState(() => _priceRange = value),
            ),
            const SizedBox(height: 50),

            // Tombol Rekomendasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSkinType != null && _selectedConcerns.isNotEmpty ? _submit : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'DAPATKAN REKOMENDASI',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }
}