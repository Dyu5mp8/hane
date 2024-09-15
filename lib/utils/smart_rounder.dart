import 'dart:math';

num smartRound(double value) {
  if (value == 0.0) return 0;

  double absValue = value.abs();
  int digits;

  if (absValue >= 1) {
    digits = (log(absValue) / ln10).floor() + 1;
  } else {
    digits = 1;
  }

  if (digits >= 3) {
    double factor = pow(10, digits - 3).toDouble();
    return ( (value / factor).round() * factor ).toInt();
  } else {
    int decimalPlaces = 3 - digits;
    double roundedValue = (value * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
    // Ensure two decimal places as per original function
    return double.parse(roundedValue.toStringAsFixed(decimalPlaces));
  }
}