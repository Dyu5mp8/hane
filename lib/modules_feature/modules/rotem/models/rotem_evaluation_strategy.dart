import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';

abstract class RotemEvaluationStrategy {
  String get name;
  double heptemCutoff = 1.2;

  Map<String, List<RotemAction>> evaluate(RotemEvaluator evaluator);
  List<FieldConfig> getRequiredFields();

  int getTotalSectionsForStrategy() {
  final requiredFields = getRequiredFields();
  final distinctSections = requiredFields.map((fc) => fc.section).toSet();
  return distinctSections.length;
}

  /// Global validation logic that checks multiple fields together.
  /// Return a string with an error message if invalid, or null if all good.
  String? validateAll(Map<RotemField, String?> values) => null;

  bool isValueBelowMin(FieldConfig config, double value) =>
      (config.minValue != null && value < config.minValue!);

  bool isValueAboveMax(FieldConfig config, double value) =>
      (config.maxValue != null && value > config.maxValue!);

  bool isValueOutOfRange(FieldConfig config, double value) {
  return (config.result(value) == Result.normal);
  }
}
