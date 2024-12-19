import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';

class RotemEvaluator {
  final double? ctExtem;
  final double? ctIntem;
  final double? a10Fibtem;
  final double? a5Fibtem;
  final double? a10Extem;
  final double? a5Extem;
  final double? mlExtem;
  final double? ctHeptem;
  final RotemEvaluationStrategy strategy;

  RotemEvaluator({
    this.ctExtem,
     this.ctIntem,
     this.a10Fibtem,
     this.a5Fibtem,
     this.a10Extem,
     this.a5Extem,
     this.mlExtem,
     this.ctHeptem,
     required this.strategy,
  });

  Map<String, String> evaluate() {
    return strategy.evaluate(this);
  }
}