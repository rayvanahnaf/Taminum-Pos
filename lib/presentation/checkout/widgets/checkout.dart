import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../services/receipt_printer.dart';
import '../../../services/excel_exporter.dart';

class CheckoutScreen extends StatelessWidget {
  // Versi lama, jangan dihapus
  // final Map<Product, int> orders;
  //
  // const CheckoutScreen({Key? key, required this.orders}) : super(key: key);
  //
  // double get totalPrice {
  //   double total = 0;
  //   orders.forEach((product, qty) {
  //     total += product.price * qty;
  //   });
  //   return total;
  // }

  // Versi baru sementara: data statik
  final List<Map<String, dynamic>> staticOrders = [
    {
      'name': 'Kaos Polos',
      'qty': 2,
      'price': 50000.0,
    },
    {
      'name': 'Minuman Segar',
      'qty': 1,
      'price': 15000.0,
    },
  ];

  CheckoutScreen({Key? key}) : super(key: key);

  double getStaticTotalPrice() {
    double total = 0;
    for (var item in staticOrders) {
      total += item['price'] * item['qty'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = getStaticTotalPrice(); // versi data statik

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
              child: ListView.builder(
                itemCount: staticOrders.length,
                itemBuilder: (context, index) {
                  final item = staticOrders[index];
                  final subtotal = item['price'] * item['qty'];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Qty: ${item['qty']}'),
                    trailing: Text('Rp${subtotal.toStringAsFixed(0)}'),
                  );
                },
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
                  'Rp${totalPrice.toStringAsFixed(0)}',
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
                    onPressed: () {
                      // dummy print untuk data statik
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
