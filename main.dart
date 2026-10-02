import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Product {
  final String name;
  final String description;
  final int price;
  final Color color;
  final String label;
  int rating; // 0 to 3 stars

  Product(this.name, this.description, this.price, this.color, this.label,
      {this.rating = 0});
}

final List<Product> products = [
  Product('Pixel', 'Pixel is the most featured phone ever', 800,
      const Color(0xFF3B63DB), 'pixel 1'),
  Product('Laptop', 'Laptop is most productive development tool', 2000,
      const Color(0xFF3FD63A), 'laptop'),
  Product('Tablet', 'Tablet is the most useful device ever for meeting', 1500,
      const Color(0xFFCDC72E), 'tablet',
      rating: 3),
  Product('Pendrive', 'iPhone is the stylish phone ever', 100,
      const Color(0xFFC4604A), 'pen drive'),
  Product('Floppy Drive', 'iPhone is the stylish phone ever', 20,
      const Color(0xFF41BCA8), 'floppy'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Navigation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductListPage(),
    );
  }
}

/// Three tappable stars. Tap star N to rate N stars (1-3).
/// Tapping the star that matches the current rating clears it back to 0.
class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  const StarRating({super.key, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final starNumber = i + 1;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          icon: Icon(
            starNumber <= rating ? Icons.star : Icons.star_border,
            color: Colors.red,
            size: 20,
          ),
          onPressed: () => onChanged(starNumber == rating ? 0 : starNumber),
        );
      }),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Navigation')),
      body: ListView.builder(
        padding: const EdgeInsets.all(2),
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
              );
              setState(() {}); // refresh stars after coming back
            },
            child: Card(
              child: SizedBox(
                height: 135,
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      color: p.color,
                      alignment: Alignment.center,
                      child: Text(p.label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w300)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(p.description,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12)),
                            Text('Price: ${p.price}',
                                style: const TextStyle(fontSize: 12)),
                            StarRating(
                              rating: p.rating,
                              onChanged: (r) => setState(() => p.rating = r),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      // AppBar automatically shows a back arrow that returns to the home page.
      appBar: AppBar(title: Text(p.name)),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            color: p.color,
            alignment: Alignment.center,
            child: Text(p.label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w200)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(p.description, textAlign: TextAlign.center),
                  Text('Price: ${p.price}'),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StarRating(
                      rating: p.rating,
                      onChanged: (r) => setState(() => p.rating = r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
