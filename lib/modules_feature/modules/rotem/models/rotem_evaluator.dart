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
  double? ctExtem;
  double? ctIntem;
  double? a10Fibtem;
  double? a5Fibtem;
  double? a10Extem;
  double? a5Extem;
  double? mlExtem;
  double? ctHeptem;
  double? ctFibtem;
  double? li30Extem;
  RotemEvaluationStrategy? _strategy;

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
  });

  RotemEvaluationStrategy? get strategy => _strategy;
  set strategy(RotemEvaluationStrategy? value) {
    _strategy = value;
  }

  void clear() {
    ctFibtem = null;
    a5Fibtem = null;
    a10Fibtem = null;
    ctExtem = null;
    a5Extem = null;
    a10Extem = null;
    mlExtem = null;
    li30Extem = null;
    ctIntem = null;
    ctHeptem = null;
  }

  /// Parses values from the provided map and updates the evaluator's fields.
  /// Also sets the evaluation strategy.
  void parseAndSet(Map<RotemField, String> inputValues) {
    ctFibtem = double.tryParse(inputValues[RotemField.ctFibtem] ?? '');
    a5Fibtem = double.tryParse(inputValues[RotemField.a5Fibtem] ?? '');
    a10Fibtem = double.tryParse(inputValues[RotemField.a10Fibtem] ?? '');
    ctExtem = double.tryParse(inputValues[RotemField.ctExtem] ?? '');
    a5Extem = double.tryParse(inputValues[RotemField.a5Extem] ?? '');
    a10Extem = double.tryParse(inputValues[RotemField.a10Extem] ?? '');
    mlExtem = double.tryParse(inputValues[RotemField.mlExtem] ?? '');
    li30Extem = double.tryParse(inputValues[RotemField.li30Extem] ?? '');
    ctIntem = double.tryParse(inputValues[RotemField.ctIntem] ?? '');
    ctHeptem = double.tryParse(inputValues[RotemField.ctHeptem] ?? '');
  }

  Map<String, List<RotemAction>> evaluate() {
    if (strategy == null) {
      throw Exception('Strategy must be set before evaluation.');
    }
    return strategy!.evaluate(this);
  }
}
