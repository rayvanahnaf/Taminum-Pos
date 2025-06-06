import 'package:flutter/material.dart';
import '../../models/product.dart';

class KitchenOrders extends StatelessWidget {
  final Map<Product, int> orders;
  final Function(Product) onIncrease;
  final Function(Product) onDecrease;
  final Function(Product) onRemoveOrder;

  const KitchenOrders({
    Key? key,
    required this.orders,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemoveOrder,
  }) : super(key: key);

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
          const Text('Kitchen Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Expanded(
            child: orders.isEmpty
                ? const Text('No orders yet', style: TextStyle(color: Colors.white70))
                : ListView(
              children: orders.entries.map((entry) {
                final product = entry.key;
                final qty = entry.value;
                return Card(
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(product.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('Qty: $qty | \$${(product.price * qty).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white70)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white),
                          onPressed: () => onDecrease(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => onIncrease(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onRemoveOrder(product),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
