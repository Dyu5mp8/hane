
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';

abstract class RotemEvaluationStrategy {
  Map<String, String> evaluate(RotemEvaluator evaluator);
  List<FieldConfig> getRequiredFields();
  
  /// Global validation logic that checks multiple fields together.
  /// Return a string with an error message if invalid, or null if all good.
  String? validateAll(Map<RotemField, String?> values) => null;
}