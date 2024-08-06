import 'package:flutter/material.dart';

enum ConversionType { weight, time, concentration }

class ConversionColor {
  static final Map<ConversionType, Color> _conversionColorMap = {
    ConversionType.weight: Colors.blue,
    ConversionType.time: Colors.red,
    ConversionType.concentration: Colors.green,
  };

  static Color getColor(ConversionType type, {bool isActive = true}) {
    // Default to a grey color if not active
    Color baseColor = _conversionColorMap[type] ?? Colors.grey;
    return isActive ? baseColor : Colors.grey;
  }
}