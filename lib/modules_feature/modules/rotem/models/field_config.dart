import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';

typedef FieldValidator = String? Function(String? value);

/// FieldConfig now carries optional minValue and maxValue.
/// If a field is below minValue or above maxValue, it's "out of range."
class FieldConfig {
  final String label;
  final RotemField field;
  final RotemSection section;
  final bool isRequired;

  /// If not null, a field value below this is out of range.
  final double? minValue;

  /// If not null, a field value above this is out of range.
  final double? maxValue;

  const FieldConfig({
    required this.label,
    required this.field,
    required this.section,
    this.minValue,
    this.maxValue,
    this.isRequired = true,
  });

  Result? result(double? value) {
    if (value == null) return null;
    if (minValue != null && value < minValue!) return Result.low;
    if (maxValue != null && value > maxValue!) return Result.high;
    return Result.normal;
  }
}

enum Result { normal, low, high }
