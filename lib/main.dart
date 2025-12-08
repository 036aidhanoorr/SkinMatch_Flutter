import 'package:flutter/material.dart';

void main() => runApp(const SkinMatchApp());

class SkinMatchApp extends StatelessWidget {
  const SkinMatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('SkinMatch Explore')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ProductCard(name: 'Niacinamide Serum', brand: 'The Ordinary', price: '150.000'),
            ProductCard(name: 'Sunscreen SPF 50', brand: 'Biore', price: '55.000'),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name, brand, price;
  const ProductCard({super.key, required this.name, required this.brand, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Text(brand),
        trailing: Text('Rp $price'),
      ),
    );
  }
}