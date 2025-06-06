import 'package:flutter/material.dart';
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart'; // Pastikan ini adalah import yang benar
import 'package:flutter_pos/core/constants/color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderCard extends StatelessWidget {
  final Product product; // Ini harus dari product_response_model.dart
  final int quantity;
  final Function(int) onQuantityChanged; // Callback untuk mengubah jumlah

  const OrderCard({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged, // Tambahkan parameter ini
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              height: 90,
              width: 90,
              fit: BoxFit.fitWidth,
              imageUrl: '${Variables.imageBaseUrl}${product.imageUrl}',
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(
                Icons.food_bank_outlined,
                size: 50,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp${double.parse(product.price).toStringAsFixed(2)}', // Format harga
                  style: TextStyle(color: secondaryTextColor),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () {
                  if (quantity > 1) {
                    onQuantityChanged(quantity - 1); // Kurangi jumlah
                  } else {
                    onQuantityChanged(0); // Hapus produk jika jumlah menjadi 0
                  }
                },
              ),
              Text(
                '$quantity',
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  onQuantityChanged(quantity + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}