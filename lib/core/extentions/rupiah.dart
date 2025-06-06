
import 'package:intl/intl.dart';

extension Rupiah on String {

  String get toRupiah {
    final parsedValue = int.tryParse(this) ?? 0;
    return NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(parsedValue);
  }
}