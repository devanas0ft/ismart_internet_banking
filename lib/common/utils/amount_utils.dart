class AmountUtils {
  static double getAmountInPaisa({required String amount}) {
    double data = 0.0;

    data = (double.tryParse(amount) ?? 0.0) * 100;
    return data;
  }

  static double getAmountInRupees({required String amount}) {
    double data = 0.0;

    data = (double.tryParse(amount) ?? 0.1) / 100;
    return data;
  }
}
