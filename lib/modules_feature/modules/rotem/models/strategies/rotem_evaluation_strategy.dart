import 'package:hane/drugs/models/drug.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_action.dart';

abstract class RotemEvaluationStrategy {
  String get name;

  Map<String, List<RotemAction>> evaluate(RotemEvaluator evaluator);
  List<FieldConfig> getRequiredFields();
  
  /// Global validation logic that checks multiple fields together.
  /// Return a string with an error message if invalid, or null if all good.
  String? validateAll(Map<RotemField, String?> values) => null;

  bool isValueBelowMin(FieldConfig config, double value) =>
    (config.minValue != null && value < config.minValue!);

  bool isValueAboveMax(FieldConfig config, double value) =>
    (config.maxValue != null && value > config.maxValue!);

  bool isValueOutOfRange(FieldConfig config, double value) {
    if (config.minValue != null && value < config.minValue!) {
      return true;
    }
    if (config.maxValue != null && value > config.maxValue!) {
      return true;
    }
    return false;
  }
}