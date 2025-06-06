import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final int totalOrders;
  final VoidCallback onCheckout;

  const OrderSummary({Key? key, required this.totalOrders, required this.onCheckout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Products: $totalOrders',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onCheckout,
            child: const Text('Checkout'),
          )
        ],
      ),
    );
  }
}
