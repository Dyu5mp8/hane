import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';


enum RotemField {
  ctExtem,
  ctIntem,
  ctFibtem,
  a5Fibtem,
  a10Fibtem,
  a5Extem,
  a10Extem,
  mlExtem,
  ctHeptem,
  li30Extem,
}

enum RotemSection { fibtem, extem, intem, heptem }

class RotemEvaluator {
  final double? ctExtem;
  final double? ctIntem;
  final double? a10Fibtem;
  final double? a5Fibtem;
  final double? a10Extem;
  final double? a5Extem;
  final double? mlExtem;
  final double? ctHeptem;
  final double? ctFibtem;
  final double? li30Extem;
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
    this.ctFibtem,
    this.li30Extem,
    required this.strategy,
  });

  Map<String, List<RotemAction>> evaluate() {
    return strategy.evaluate(this);
  }
}
