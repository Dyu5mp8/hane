import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';

class TraumaEvaluationStrategy implements RotemEvaluationStrategy {
  @override
  Map<String, String> evaluate(RotemEvaluator evaluator) {
    Map<String, String> actions = {};

    // Rule 1: PCC (EXTEM) and/or FFP (EXTEM/INTEM)
    if (evaluator.ctExtem != null && evaluator.ctExtem! > 79) {
      if (evaluator.ctIntem != null && evaluator.ctIntem! > 240) {
        actions["FFP"] = "Högt CT EXTEM och INTEM";
      } else {
        actions["PCC"] = "Högt CT EXTEM";
      }
    } else if (evaluator.ctIntem != null && evaluator.ctIntem! > 240) {
      actions["FFP"] = "Högt CT INTEM";
    }

    // Rule 2: Fibrinogen
    if (_lowFibTem(evaluator)) {
      actions["Fibrinogen"] = "Lågt Fibtem";
    }

    // Rule 3: Platelets
    if (!_lowFibTem(evaluator) && _lowExtem(evaluator)) {
      actions["Trombocyter"] = "Lågt EXTEM";
    }

    // Rule 4: Tranexamic acid
    if (evaluator.mlExtem != null && evaluator.mlExtem! > 15) {
      actions["Tranexamic acid"] = "Högt ML EXTEM";
    }

    // Rule 5: Protamine
    if (evaluator.ctHeptem != null &&
        evaluator.ctIntem != null &&
        evaluator.ctHeptem! / evaluator.ctIntem! > 1.1) {
      actions["Protamin"] = "Skillnad mellan CT HEPTEM och INTEM mer än 10%";
    }

    return actions;
  }

  bool _lowFibTem(RotemEvaluator evaluator) {
    return (evaluator.a10Fibtem != null && evaluator.a10Fibtem! < 12) ||
        (evaluator.a5Fibtem != null && evaluator.a5Fibtem! < 11);
  }

  bool _lowExtem(RotemEvaluator evaluator) {
    return (evaluator.a10Extem != null && evaluator.a10Extem! < 43) ||
        (evaluator.a5Extem != null && evaluator.a5Extem! < 34);
  }
}