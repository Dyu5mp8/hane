import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';


class ThoraxEvaluationStrategy implements RotemEvaluationStrategy {
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

  @override
  List<FieldConfig> getRequiredFields() {
    // Specify the fields this strategy requires and their sections.
    // For this example, we include all fields that are used in evaluation logic.
    return [
      FieldConfig(
        label: "CT EXTEM",
        field: RotemField.ctExtem,
        section: RotemSection.extem,
      ),
      FieldConfig(
        label: "CT INTEM",
        field: RotemField.ctIntem,
        section: RotemSection.intem,
      ),
      FieldConfig(
        label: "A5 FIBTEM",
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
      ),
      FieldConfig(
        label: "A10 FIBTEM",
        field: RotemField.a10Fibtem,
        section: RotemSection.fibtem,
      ),
      FieldConfig(
        label: "A5 EXTEM",
        field: RotemField.a5Extem,
        section: RotemSection.extem,
      ),
      FieldConfig(
        label: "A10 EXTEM",
        field: RotemField.a10Extem,
        section: RotemSection.extem,
      ),
      FieldConfig(
        label: "ML EXTEM",
        field: RotemField.mlExtem,
        section: RotemSection.extem,
      ),
      FieldConfig(
        label: "CT HEPTEM",
        field: RotemField.ctHeptem,
        section: RotemSection.heptem,
      ),
    ];
  }
@override
  String? validateAll(Map<RotemField, String?> values) {
    final ctExtemValue = values[RotemField.ctExtem];
    final ctIntemValue = values[RotemField.ctIntem];
    final a5FibtemValue = values[RotemField.a5Fibtem];
    final a10FibtemValue = values[RotemField.a10Fibtem];
    final a5ExtemValue = values[RotemField.a5Extem];
    final a10ExtemValue = values[RotemField.a10Extem];
    final mlExtemValue = values[RotemField.mlExtem];

    // 1) Either CT EXTEM or CT INTEM must be filled
    if ((ctExtemValue == null || ctExtemValue.isEmpty) &&
        (ctIntemValue == null || ctIntemValue.isEmpty)) {
      return 'Antingen CT EXTEM eller CT INTEM måste fyllas i.';
    }

    // 2) Either A10 FIBTEM or A5 FIBTEM must be filled
    if ((a10FibtemValue == null || a10FibtemValue.isEmpty) &&
        (a5FibtemValue == null || a5FibtemValue.isEmpty)) {
      return 'Antingen A10 FIBTEM eller A5 FIBTEM måste fyllas i.';
    }

    // 3) Either A10 EXTEM or A5 EXTEM must be filled
    if ((a10ExtemValue == null || a10ExtemValue.isEmpty) &&
        (a5ExtemValue == null || a5ExtemValue.isEmpty)) {
      return 'Antingen A10 EXTEM eller A5 EXTEM måste fyllas i.';
    }

    // 4) ML EXTEM must be filled
    if (mlExtemValue == null || mlExtemValue.isEmpty) {
      return 'ML EXTEM måste fyllas i.';
    }

    // If no errors:
    return null;
  }
}