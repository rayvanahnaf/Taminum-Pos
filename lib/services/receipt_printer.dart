import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../models/product.dart';

class ReceiptPrinter {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> printReceipt(Map<Product, int> orders) async {
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    if (devices.isEmpty) return;

    BluetoothDevice printer = devices.first; // You can let user choose
    await bluetooth.connect(printer);

    bluetooth.printNewLine();
    bluetooth.printCustom("FLUTTER POS", 3, 1);
    bluetooth.printNewLine();

    double total = 0;
    orders.forEach((product, qty) {
      double subtotal = product.price * qty;
      bluetooth.printCustom("${product.name} x$qty - \$${subtotal.toStringAsFixed(2)}", 1, 0);
      total += subtotal;
    });

    bluetooth.printNewLine();
    bluetooth.printCustom("TOTAL: \$${total.toStringAsFixed(2)}", 2, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom("Thank You!", 2, 1);
    bluetooth.printNewLine();
    bluetooth.paperCut(); // May not work with all printers
  }
}
