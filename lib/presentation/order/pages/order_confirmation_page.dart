import 'package:flutter/material.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart'; // Import model yang benar
import 'package:flutter_pos/presentation/order/widgets/button_confirmation.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class OrderConfirmationPage extends StatelessWidget {
  final Map<Product, int> cart;
  final double total;
  final String customerName;
  final String table;

  const OrderConfirmationPage({
    Key? key,
    required this.cart,
    required this.total,
    required this.customerName,
    required this.table,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🧾 Order Receipt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800], // Judul hijau
                ),
              ),
              const Divider(),
              Text('Customer: $customerName',
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text('Table: $table',
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 12),

              // Item List
              ...cart.entries.map((entry) {
                final product = entry.key;
                final qty = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('x$qty', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                );
              }).toList(),

              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonConfirmation(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.arrow_back,
                    label: 'Back',
                  ),
                  ButtonConfirmation(
                    onPressed: () => _printReceipt(),
                    icon: Icons.print,
                    label: 'Print',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _printReceipt() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) =>
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10), // beri margin kiri-kanan
              child: pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Header
                    pw.Text('Taminum',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 4),
                    pw.Text('123 Business Address, City',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 4),
                    pw.Text('Tel: (123) 456-7890 | Tax ID: 123456789',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 8),
                    pw.Text('RECEIPT',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 8),

                    // Customer info
                    pw.Text('Customer: $customerName', style: pw.TextStyle(fontSize: 10)),
                    pw.Text('Table: $table', style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 8),
                    pw.Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.Divider(thickness: 1),

                    // Item header
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),

                    // Items
                    ...cart.entries.map((entry) {
                      final product = entry.key;
                      final qty = entry.value;
                      final itemTotal = double.parse(product.price) * qty; // Pastikan price adalah string

                      return pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(product.name, style: const pw.TextStyle(fontSize: 9)),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text('x$qty', style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.center),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text('\$${product.price}', style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text('\$${itemTotal.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    pw.Divider(thickness: 1),

                    // Totals
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Subtotal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('\$${total.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Tax (0%):', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('\$0.00', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                        pw.Text('\$${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      ],
                    ),

                    // Footer
                    pw.SizedBox(height: 12),
                    pw.Text('Thank you for your business!', style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 6),
                    pw.Text('Returns accepted within 14 days with receipt', style: const pw.TextStyle(fontSize: 8)),
                    pw.Text('Page 1 of 1', style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}