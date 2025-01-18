import 'package:hane/drugs/models/drug.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';

class ObstetricEvaluationStrategy extends RotemEvaluationStrategy {
  @override
  String get name => "Obstetrisk blödning";

  @override
  List<FieldConfig> getRequiredFields() {
    return [
      const FieldConfig(
        label: "CT EXTEM",
        field: RotemField.ctExtem,
        section: RotemSection.extem,
        // Normal range might be up to 79. 
        // If CT EXTEM is above 79, we consider it out of range.
        maxValue: 80,
        isRequired: true
      ),
      const FieldConfig(
        label: "CT INTEM",
        field: RotemField.ctIntem,
        section: RotemSection.intem,
        // Example threshold for out-of-range
        maxValue: 240,
        isRequired: false
  
      ),
      const FieldConfig(
        label: "A5 FIBTEM",
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
        minValue: 12,
        isRequired: true
      ),
      const FieldConfig(
        label: "A5 EXTEM",
        field: RotemField.a5Extem,
        section: RotemSection.extem,
        minValue: 34,
        isRequired: true
      ),
      const FieldConfig(
        label: "ML EXTEM",
        field: RotemField.mlExtem,
        section: RotemSection.extem,
        maxValue: 10,
        isRequired: false
      ),
      const FieldConfig(
        label: "CT FIBTEM",
        field: RotemField.ctFibtem,
        section: RotemSection.fibtem,
        maxValue: 600,
      ),

          // add CT HEPTEM HERE IF NECESSARY
    ];
  }
  
  
  @override
  Map<String, List<RotemAction>> evaluate(RotemEvaluator evaluator) {
    final configs = {
      for (final cfg in getRequiredFields()) cfg.field: cfg
    };

    final actions = <String, List<RotemAction>>{};

    // Extract numeric values from evaluator
    final a5Fibtem = evaluator.a5Fibtem;     // A5 FIBTEM
    final a5Extem = evaluator.a5Extem;       // A5 EXTEM
    final ctExtem = evaluator.ctExtem;       // CT EXTEM
    final ctIntem = evaluator.ctIntem;       // CT INTEM
    final ctFibtem = evaluator.ctFibtem;     // CT FIBTEM (make sure RotemEvaluator has this!)
    final mlExtem = evaluator.mlExtem;   
        final ctHeptem = evaluator.ctHeptem;   // ML EXTEM


    //----------------------------------------------------------------------
    // 1) Fibrinogen if A5 FIBTEM < 12 mm
    //----------------------------------------------------------------------
    if (configs[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.low) {
      actions['Låg A5 FIBTEM'] = [RotemAction(
        dosage: Dosage(
          instruction: "Fibrinogen",  
          administrationRoute: "IV",
          lowerLimitDose: Dose.fromString(amount: 2, unit: "g"),
          higherLimitDose: Dose.fromString(amount: 4, unit: "g"),
        ),
      )];
    }

    //----------------------------------------------------------------------
    // 2) Platelets if (A5 FIBTEM ≥ 12 mm) AND (A5 EXTEM < 35 mm)
    //----------------------------------------------------------------------
    if (configs[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.normal &&
        configs[RotemField.a5Extem]?.result(a5Extem) == Result.low) {
      actions['Normal A5 FIBTEM samt låg A5 EXTEM'] = [RotemAction(
        dosage: Dosage(
          instruction: "Trombocytkoncentrat",
          administrationRoute: "IV",
          dose: Dose.fromString(amount: 1, unit: "E"),
        ),
      )];
    }

    //----------------------------------------------------------------------
    // 3) Ocplex/Confidex 10E/kg eller plasma 10-15 ml/kg om (CT EXTEM > 80 s) OCH (A5 FIBTEM ≥ 12 mm)
    //----------------------------------------------------------------------
    if (configs[RotemField.ctExtem]?.result(ctExtem) == Result.high &&
        configs[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.normal) {
      actions['Förlängd CT EXTEM samt normal A5 FIBTEM'] = 
      [
      RotemAction(
        dosage: Dosage(
          instruction: "Plasma",
          administrationRoute: "IV",
          lowerLimitDose: Dose.fromString(amount: 10, unit: "ml/kg"),
          higherLimitDose: Dose.fromString(amount: 15, unit: "ml/kg"),
        ),
      ),
      RotemAction(
        dosage: Dosage(
          instruction: "Ocplex/Confidex",
          administrationRoute: "IV",
          dose: Dose.fromString(amount: 10, unit: "E/kg"),
        ),
      ),
      ];
    }

    //----------------------------------------------------------------------
    // 4) Plasma if CT INTEM > 240 s and step 3 not taken
    //----------------------------------------------------------------------
    else if (configs[RotemField.ctIntem]?.result(ctIntem) == Result.high) {
      actions['Förlängd CT INTEM'] = [RotemAction(
        dosage: Dosage(
          instruction: "Plasma",
          administrationRoute: "IV",
          dose: Dose.fromString(amount: 10, unit: "ml/kg"),
        ),
      )];
    }

    //----------------------------------------------------------------------
    // 5) Cyklokapron if (CT FIBTEM > 600 s) OR (ML EXTEM > 10%)
    //----------------------------------------------------------------------
    if (configs[RotemField.ctFibtem]?.result(ctFibtem) == Result.high ||
        configs[RotemField.mlExtem]?.result(mlExtem) == Result.high) {
      actions['CT FIBTEM > 600 s eller ML EXTEM > 10%'] = [RotemAction(
        dosage: Dosage(
          instruction: "Cyklokapron",
          administrationRoute: "IV",
          dose: Dose.fromString(amount: 20, unit: "mg/kg"),
        ),
      )];
    }

    // 5) Protamin if CT INTEM > CT HEPTEM
    if (ctIntem != null && ctHeptem != null && ctIntem/ctHeptem > heptemCutoff) {
      actions['Protamin'] = [RotemAction(
        dosage: Dosage(
          administrationRoute: "IV",
          instruction: "Ge protamin",
          lowerLimitDose: Dose.fromString(amount: 50, unit: "mg"),
        ),
      )];
    }

    return actions;
  }


  @override
  String? validateAll(Map<RotemField, String?> values) {
   final a5FibtemVal = values[RotemField.a5Fibtem];
    final a5ExtemVal  = values[RotemField.a5Extem];
    final ctExtemVal  = values[RotemField.ctExtem];

    if (a5FibtemVal == null || a5FibtemVal.isEmpty) {
      return 'A5 FIBTEM måste fyllas i.';
    }
    if (a5ExtemVal == null || a5ExtemVal.isEmpty) {
      return 'A5 EXTEM måste fyllas i.';
    }
    if (ctExtemVal == null || ctExtemVal.isEmpty) {
      return 'CT EXTEM måste fyllas i.';
    }

    return null;
  
  }
}