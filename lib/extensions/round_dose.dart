import 'dart:math';

extension Round on double {
  String weightRound({bool rounded = false}) {
    if (this == 0.0) return "0";
    if (rounded) {
      // Determine the appropriate increment based on the absolute value.
      final absValue = abs();
      double increment;

      if (absValue < 20) {
        // For numbers less than 20, round to the nearest 0.1.
        increment = 0.1;
      } else if (absValue < 50) {
        // For numbers less than 50, round to the nearest 0.5.
        increment = 0.5;
      } else {
        increment = 1;
      }

      // Round this value to the nearest multiple of the chosen increment.
      final rounded = (this / increment).round() * increment;

      // Format the result.
      String result;
      if (increment < 1) {
        // Determine the number of decimals needed.
        // For example, if increment = 0.05, we need 2 decimals.
        final decimals = (-log(increment) / ln10).ceil();
        result = rounded.toStringAsFixed(decimals);
      } else {
        result = rounded.toStringAsFixed(0);
      }

      return _stripTrailingZeros(result);
    } else {
      return _stripTrailingZeros(toStringAsFixed(5));
    }
  }

  String doseAmountRepresentation({bool rounded = false}) {
    if (this == 0.0) return "0";
    if (rounded) {
      // Determine the appropriate increment based on the absolute value.
      final absValue = abs();
      double increment;
      if (absValue < 0.1) {
        increment = 0.005;
      } else if (absValue < 1) {
        increment = 0.01;
      } else if (absValue < 20) {
        // For numbers less than 100, round to the nearest 0.05.
        increment = 0.05;
      } else if (absValue < 50) {
        // For numbers less than 100, round to the nearest 0.05.
        increment = 0.5;
      } else if (absValue < 100) {
        // For numbers less than 100, round to the nearest 0.05.
        increment = 1;
      } else if (absValue < 2000) {
        // For numbers between 100 and 1000, round to the nearest 5.
        increment = 5;
      } else if (absValue < 10000) {
        // For numbers between 1000 and 10000, round to the nearest 100.
        increment = 100;
      } else {
        // For larger numbers, you can generalize:
        // For example, round to 1% of the highest power of ten.
        final base = pow(10, (log(absValue) / ln10).floor()).toDouble();
        increment = 0.01 * base;
      }

      // Round this value to the nearest multiple of the chosen increment.
      final rounded = (this / increment).round() * increment;

      // Format the result.
      String result;
      if (increment < 1) {
        // Determine the number of decimals needed.
        // For example, if increment = 0.05, we need 2 decimals.
        final decimals = (-log(increment) / ln10).ceil();
        result = rounded.toStringAsFixed(decimals);
      } else {
        result = rounded.toStringAsFixed(0);
      }

      return _stripTrailingZeros(result);
    } else {
      return _stripTrailingZeros(toStringAsFixed(5));
    }
  }

  /// Splits the number at the decimal point and strips trailing zeros from the fractional part.
  String _stripTrailingZeros(String s) {
    if (!s.contains('.')) return s;
    final parts = s.split('.');
    final integerPart = parts[0];
    final fraction = parts[1].replaceAll(RegExp(r'0+$'), '');
    return fraction.isEmpty ? integerPart : '$integerPart.$fraction';
  }
}
