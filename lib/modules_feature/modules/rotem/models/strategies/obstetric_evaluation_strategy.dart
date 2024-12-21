import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';

class ObstetricEvaluationStrategy implements RotemEvaluationStrategy {
  @override
  List<FieldConfig> getRequiredFields() {
    return [
      FieldConfig(
        label: "A5 FIBTEM",
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
        required: false,
      ),
      FieldConfig(
        label: "A10 FIBTEM",
        field: RotemField.a10Fibtem,
        section: RotemSection.fibtem,
        required: false,
      ),
      FieldConfig(
        label: "CT INTEM",
        field: RotemField.ctIntem,
        section: RotemSection.intem,
        required: false,
      ),
      FieldConfig(
          label: "A5 EXTEM",
          field: RotemField.a5Extem,
          section: RotemSection.extem,
          required: true),

      FieldConfig(label: "CT EXTEM",
          field: RotemField.ctExtem,
          section: RotemSection.extem,
          required: true),

      FieldConfig(label: "CT FIBTEM",
          field: RotemField.ctFibtem,
          section: RotemSection.fibtem,
          required: true),

      FieldConfig(label: "ML EXTEM",
          field: RotemField.mlExtem,
          section: RotemSection.extem,
          required: true),
    ];
  }

  @override
  String? validateAll(Map<RotemField, String?> values) {
    // Example: require either A5 FIBTEM or A10 FIBTEM to be filled in
    final a5 = values[RotemField.a5Fibtem];
    final a10 = values[RotemField.a10Fibtem];

    if ((a5 == null || a5.isEmpty) && (a10 == null || a10.isEmpty)) {
      return 'Antingen A5 FIBTEM eller A10 FIBTEM måste fyllas i.';
    }

    // If no error:
    return null;
  }

  @override
  Map<String, String> evaluate(RotemEvaluator evaluator) {
    Map<String, String> actions = {};

    // Rule 1: A5 FIBTEM < 12 mm → Fibrinogen
    if (evaluator.a5Fibtem != null && evaluator.a5Fibtem! < 12) {
      actions["Fibrinogen"] = "Fibrinogen 2-4 g (MÅL: A5 FIBTEM ≥ 16 mm)";
    }

    // Rule 2: A5 FIBTEM ≥ 12 mm and A5 EXTEM < 35 mm → Platelets
    if (evaluator.a5Fibtem != null &&
        evaluator.a5Fibtem! >= 12 &&
        evaluator.a5Extem != null &&
        evaluator.a5Extem! < 35) {
      actions["Trombocyter"] = "Trombocyter 1 E";
    }

    // Rule 3: CT EXTEM > 80 s and A5 FIBTEM ≥ 12 mm → Ocplex/Confidex or Plasma
    if (evaluator.ctExtem != null &&
        evaluator.ctExtem! > 80 &&
        evaluator.a5Fibtem != null &&
        evaluator.a5Fibtem! >= 12) {
      actions["Ocplex/Confidex"] =
          "Ocplex®/Confidex® 10 IE/kg eller plasma 10-15 ml/kg";
    }

    // Rule 4: CT INTEM > 240 s → Plasma
    if (evaluator.ctIntem != null && evaluator.ctIntem! > 240) {
      actions["Plasma"] = "Plasma 10 ml/kg";
    }

    // Rule 5: CT FIBTEM > 600 s or ML EXTEM > 10% → Tranexamic Acid
    if ((evaluator.ctFibtem != null && evaluator.ctFibtem! > 600) ||
        (evaluator.mlExtem != null && evaluator.mlExtem! > 10)) {
      actions["Cyklokapron"] = "Cyklokapron® 1-2 g (20 mg/kg)";
    }

    return actions;
  }
}
