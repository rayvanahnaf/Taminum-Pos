import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportOrdersToExcel(Map<Product, int> orders) async {
  final excel = Excel.createExcel();
  final Sheet sheet = excel['Orders'];

  // Header
  sheet.appendRow(['Product', 'Quantity', 'Price', 'Subtotal']);

  // Data rows
  for (var entry in orders.entries) {
    final product = entry.key;
    final qty = entry.value;
    final subtotal = product.price * qty;
    sheet.appendRow([product.name, qty, product.price, subtotal]);
  }

  // Total
  double total = orders.entries
      .map((e) => e.key.price * e.value)
      .fold(0.0, (a, b) => a + b);
  sheet.appendRow([]);
  sheet.appendRow(['', '', 'Total', total]);

  // Minta permission
  if (await Permission.storage.request().isGranted) {
    final dir = await getExternalStorageDirectory();
    final filePath = "${dir!.path}/order_export.xlsx";
    final fileBytes = excel.encode();

    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    print('✅ File saved to $filePath');
  } else {
    print("❌ Permission denied");
  }
}
