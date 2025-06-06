import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_pos/core/constants/color.dart';
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular image using CachedNetworkImage
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  imageUrl: '${Variables.imageBaseUrl}${product.imageUrl}',
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white54, size: 50),
                ),

              ),
            ),
            const SizedBox(height: 12),

            // Product name
            Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            // Product price
            Text(
              'Rp${product.price}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
