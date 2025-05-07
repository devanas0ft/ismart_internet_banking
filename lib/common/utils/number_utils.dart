import 'package:easy_localization/easy_localization.dart';

class NumberUtils {
  static double parseDouble({required String? value, double defaultValue = 0}) {
    return double.tryParse(value ?? defaultValue.toString()) ?? defaultValue;
  }

  static int parseInt({required String? value, int defaultValue = 0}) {
    return double.tryParse(value ?? defaultValue.toString())?.toInt() ??
        defaultValue;
  }
}

extension NumberExtension on num {
  String formatInRupee() {
    final formattedAmount = NumberFormat.currency(
      symbol: "Rs.",
      customPattern: '\u00A4\u00A0##,##,##0.00',
    ).format(this);

    if (formattedAmount.endsWith('.00')) {
      return formattedAmount.substring(0, formattedAmount.length - 3);
    }
    return formattedAmount;
  }

  String format() {
    final formattedAmount = NumberFormat.currency(
      symbol: "",
      customPattern: '\u00A4\u00A0##,##,##0.00',
    ).format(this);

    if (formattedAmount.endsWith('.00')) {
      return formattedAmount.substring(0, formattedAmount.length - 3);
    }
    return formattedAmount.trim();
  }
}
