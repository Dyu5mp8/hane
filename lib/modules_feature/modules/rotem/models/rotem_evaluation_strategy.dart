import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';


abstract class RotemEvaluationStrategy {
  Map<String, String> evaluate(RotemEvaluator evaluator);
}