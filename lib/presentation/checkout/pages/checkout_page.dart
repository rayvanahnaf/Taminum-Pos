import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../services/receipt_printer.dart';
import '../../../services/excel_exporter.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<Product, int> orders;

  const CheckoutScreen({Key? key, required this.orders}) : super(key: key);

  double get totalPrice {
    double total = 0;
    orders.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: orders.entries.map((entry) {
                  final product = entry.key;
                  final qty = entry.value;
                  final subtotal = product.price * qty;

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Qty: $qty'),
                    trailing: Text('\$${subtotal.toStringAsFixed(2)}'),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text("Print Receipt"),
                    onPressed: () async {
                      await ReceiptPrinter().printReceipt(orders);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Receipt printed!")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
