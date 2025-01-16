import 'package:flutter/foundation.dart';

class DialysisParameter {
  DialysisParameter({
    required double initialValue,
    required this.minValue,
    required this.maxValue,
    this.lowWarningValue,
    this.highWarningValue,
    this.lowWarningMessage,
    this.highWarningMessage,
  }) : _value = initialValue;

  double _value;
  final double minValue;
  final double maxValue;

  /// Optional messages to show if value < minValue or > maxValue.
  final String? lowWarningMessage;
  final String? highWarningMessage;
  final double? lowWarningValue;
  final double? highWarningValue;

  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
    }
  }

  /// Returns a warning message if out of range, otherwise null.
  String? get warning {
    if (lowWarningValue != null && _value < lowWarningValue!) {
      return lowWarningMessage;
    } else if (highWarningValue != null && _value > highWarningValue!) {
      return highWarningMessage;
    }
    return null;
  }
}
