import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skinmatch_flutter/service.dart'; // Import model produk

class ResultPage extends StatelessWidget {
  final List<Product> recommendations;
  final String skinType;

  const ResultPage({
    super.key,
    required this.recommendations,
    required this.skinType,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = recommendations.fold(0.0, (sum, item) => sum + item.price);
    
    // Tentukan produk AM dan PM (Simplifikasi: Sunscreen di AM, Serum fokus di PM)
    final List<Product> amRoutine = recommendations.where((p) => p.category != 'Serum').toList();
    final List<Product> pmRoutine = recommendations.where((p) => p.category != 'Sunscreen').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinitas Skincare Anda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rekomendasi untuk Kulit $skinType',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF392A0)),
            ),
            const SizedBox(height: 20),

            // --- Total Harga ---
            _buildSummaryCard(
              context,
              'Total Estimasi Harga',
              NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(totalCost),
              Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 30),

            // --- Rutinitas Pagi (AM) ---
            _buildRoutineSection('Pagi (AM) ☀️', amRoutine, context),
            const SizedBox(height: 20),

            // --- Rutinitas Malam (PM) ---
            _buildRoutineSection('Malam (PM) 🌙', pmRoutine, context),
            
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryCard(BuildContext context, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1.5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildRoutineSection(String title, List<Product> products, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ...products.map((product) => ListTile(
              leading: Icon(
                _getIconForCategory(product.category), 
                color: Theme.of(context).primaryColor,
              ),
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(product.category),
              trailing: Text(
                NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(product.price),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )).toList(),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Cleanser':
        return Icons.water_drop;
      case 'Serum':
        return Icons.healing;
      case 'Moisturizer':
        return Icons.sentiment_satisfied;
      case 'Sunscreen':
        return Icons.wb_sunny;
      default:
        return Icons.shopping_bag;
    }
  }
}