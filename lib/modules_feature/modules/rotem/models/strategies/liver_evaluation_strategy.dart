import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';

class LiverFailureEvaluationStrategy implements RotemEvaluationStrategy {
  @override
  Map<String, String> evaluate(RotemEvaluator evaluator) {
    Map<String, String> actions = {};

    // 1) A5 FIBTEM < 8 mm AND A5 EXTEM < 25 mm -> Fibrinogen 2 g
    //    (MÅL: A5 FIBTEM >= 10 mm)
    if ((evaluator.a5Fibtem != null && evaluator.a5Fibtem! < 8) &&
        (evaluator.a5Extem != null && evaluator.a5Extem! < 25)) {
      actions["Fibrinogen"] = "2 g (MÅL: A5 FIBTEM ≥ 10 mm)";
    }

    // 2) A5 FIBTEM ≥ 8 mm AND A5 EXTEM < 25 mm -> Trombocyter 1 E
    if ((evaluator.a5Fibtem != null && evaluator.a5Fibtem! >= 8) &&
        (evaluator.a5Extem != null && evaluator.a5Extem! < 25)) {
      actions["Trombocyter"] = "1 E";
    }

    // 3) CT EXTEM > 75 s AND A5 FIBTEM >= 8 mm -> Ocplex/Confidex 500 IE or Plasma
    if ((evaluator.ctExtem != null && evaluator.ctExtem! > 75) &&
        (evaluator.a5Fibtem != null && evaluator.a5Fibtem! >= 8)) {
      actions["Ocplex/Confidex"] = "500 IE eller plasma 10-15 ml/kg";
    }

    // 4) CT INTEM > 280 s -> Plasma 10 ml/kg
    if (evaluator.ctIntem != null && evaluator.ctIntem! > 280) {
      actions["Plasma"] = "10 ml/kg";
    }

    // 5) ML EXTEM > 85% OR LI 30 EXTEM > 50% -> Cyklokapron 1-2 g (20 mg/kg)
    if (_needsTranexamicAcid(evaluator)) {
      actions["Cyklokapron"] = "1-2 g (20 mg/kg)";
    }

    return actions;
  }

  /// Helper method to check if we need Tranexamic Acid (Cyklokapron)
  bool _needsTranexamicAcid(RotemEvaluator evaluator) {
    final mlExtem = evaluator.mlExtem;
    final li30Extem = evaluator.li30Extem; // newly added property

    // If either ML EXTEM > 85% or LI30 EXTEM > 50%, return true
    if ((mlExtem != null && mlExtem > 85) ||
        (li30Extem != null && li30Extem > 50)) {
      return true;
    }
    return false;
  }

  @override
  List<FieldConfig> getRequiredFields() {
    // Return all fields used in the evaluation logic
    return [
      // A5 Fibtem
      FieldConfig(
        label: "A5 FIBTEM",
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
      ),
      // A5 Extem
      FieldConfig(
        label: "A5 EXTEM",
        field: RotemField.a5Extem,
        section: RotemSection.extem,
      ),
      // CT EXTEM
      FieldConfig(
        label: "CT EXTEM",
        field: RotemField.ctExtem,
        section: RotemSection.extem,
      ),
      // CT INTEM
      FieldConfig(
        label: "CT INTEM",
        field: RotemField.ctIntem,
        section: RotemSection.intem,
      ),
      // ML EXTEM
      FieldConfig(
        label: "ML EXTEM (%)",
        field: RotemField.mlExtem,
        section: RotemSection.extem,
      ),
      // LI 30 EXTEM (if you’ve added this field to your RotemEvaluator and RotemField)
      FieldConfig(
        label: "LI 30 EXTEM (%)",
        field: RotemField.li30Extem, // <-- Make sure you've added RotemField.li30Extem
        section: RotemSection.extem,
      ),
    ];
  }

  @override
  String? validateAll(Map<RotemField, String?> values) {
    // If you want cross-field validation, add it here.
    return null;
  }
}