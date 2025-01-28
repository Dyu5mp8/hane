import 'package:hane/drugs/models/drug.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';

class MiscEvaluationStrategy extends RotemEvaluationStrategy {
  @override String get name => "Trauma/övrigt";

  @override
  Map<String, List<RotemAction>> evaluate(RotemEvaluator evaluator) {
    final actions = <String, List<RotemAction>>{};

    // Create a quick lookup for your FieldConfig by RotemField
    final configs = {for (final cfg in getRequiredFields()) cfg.field: cfg};

    // Grab the numeric fields
    final ctExtem = evaluator.ctExtem;
    final ctIntem = evaluator.ctIntem;
    final ctHeptem = evaluator.ctHeptem;
    final a5Fibtem = evaluator.a5Fibtem;
    final a10Fibtem = evaluator.a10Fibtem;
    final a5Extem = evaluator.a5Extem;
    final a10Extem = evaluator.a10Extem;
    final mlExtem = evaluator.mlExtem;

  if (configs[RotemField.ctExtem]?.result(ctExtem) == Result.high &&
        configs[RotemField.ctIntem]?.result(ctIntem) == Result.high) {
      actions['Högt CT EXTEM/INTEM'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge plasma",
          lowerLimitDose: Dose.fromString(amount: 10, unit: "ml/kg"),
          higherLimitDose: Dose.fromString(amount: 15, unit: "ml/kg"),
        ),
      )];
    }

    // 1) PCC/FFP if CT EXTEM above max OR CT INTEM above max
    else if (configs[RotemField.ctExtem]?.result(ctExtem) == Result.high) {
      actions['Högt CT EXTEM'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge Ocplex",
          dose: Dose.fromString(amount: 10, unit: "E/kg", ),
     
    
        ),
      )];
    }

    else if (configs[RotemField.ctIntem]?.result(ctIntem) == Result.high) {
      actions['Högt CT INTEM'] = [RotemAction(
         dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge plasma",
          lowerLimitDose: Dose.fromString(amount: 10, unit: "ml/kg"),
          higherLimitDose: Dose.fromString(amount: 15, unit: "ml/kg"),
        ),
      )];
    }

    // 2) Fibrinogen if (A5 Fibtem below min) or (A10 Fibtem below min)
    final bool fibtemBelowMin =
        (configs[RotemField.a5Fibtem]?.result(a5Fibtem)) == Result.low ||
        (configs[RotemField.a10Fibtem]?.result(a10Fibtem)) == Result.low;

    if (fibtemBelowMin) {
      actions['Fibrinogen'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge fibrinogen",
          lowerLimitDose: Dose.fromString(amount: 2, unit: "g"),
          higherLimitDose: Dose.fromString(amount: 4, unit: "g"),
        ),
      )];
    }

    // 3) Platelets if EXTEM is low but FIBTEM is OK
    final extemLow =
        (configs[RotemField.a5Extem]?.result(a5Extem)) == Result.low ||
        (configs[RotemField.a10Extem]?.result(a10Extem)) == Result.low;

    final fibtemOk = !fibtemBelowMin; // "OK" if not below min

    if (extemLow && fibtemOk) {
      actions['Trombocyter'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge trombocyter",
          dose: Dose.fromString(amount: 1, unit: "E"),
        ),
      )];
    }

    // 4) Tranexamsyra if ML EXTEM above max
    if (configs[RotemField.mlExtem]?.result(mlExtem) == Result.high) {
      actions['Tranexamsyra'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge tranexamsyra",
          dose: Dose.fromString(amount: 2, unit: "g"),
        ),
      )];
    }

    // 5) Protamin if CT INTEM > CT HEPTEM
    if (ctIntem != null && ctHeptem != null && ctIntem/ctHeptem > heptemCutoff) {
      actions['Protamin'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge protamin",
          dose: Dose.fromString(amount: 50, unit: "mg"),
        ),
      )];
    }

    return actions;
  }

  @override
  List<FieldConfig> getRequiredFields() {
    return [
            const FieldConfig(
        label: "A5 FIBTEM",
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
        minValue: 11,
        isRequired: false,
      ),
      const FieldConfig(
        label: "CT EXTEM",
        field: RotemField.ctExtem,
        section: RotemSection.extem,
        maxValue: 79,
      ),
      const FieldConfig(
        label: "CT INTEM",
        field: RotemField.ctIntem,
        section: RotemSection.intem,
        maxValue: 240,
        isRequired: false
      ),

      const FieldConfig(
        label: "A10 FIBTEM",
        field: RotemField.a10Fibtem,
        section: RotemSection.fibtem,
        minValue: 12,
        isRequired: false,
      ),
      const FieldConfig(
        label: "A5 EXTEM",
        field: RotemField.a5Extem,
        section: RotemSection.extem,
        minValue: 34,
        isRequired: false

      ),
      const FieldConfig(
        label: "A10 EXTEM",
        field: RotemField.a10Extem,
        section: RotemSection.extem,
        minValue: 43,
        isRequired: false
      ),
      const FieldConfig(
        label: "ML EXTEM",
        field: RotemField.mlExtem,
        section: RotemSection.extem,
        maxValue: 15,
        isRequired: false
      ),
      const FieldConfig(label: "CT HEPTEM", field: RotemField.ctHeptem, section: RotemSection.heptem, isRequired: false),
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
    // If no errors:
    return null;
  }
}
