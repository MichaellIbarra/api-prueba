// product_widget.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/widgets/subtitle_text.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SubtitleText(
                label: "S/${product.price}",
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}