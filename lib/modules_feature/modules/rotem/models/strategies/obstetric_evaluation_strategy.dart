import 'package:hane/drugs/models/drug.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';



class ObstetricEvaluationStrategy extends RotemEvaluationStrategy {



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
        isRequired: true
  
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
        isRequired: true
      ),
      const FieldConfig(
        label: "CT FIBTEM",
        field: RotemField.ctFibtem,
        section: RotemSection.fibtem,
        maxValue: 600,
      ),
    ];
  }
  
  
  @override
  Map<String, Dosage> evaluate(RotemEvaluator evaluator) {

    final configs = {
    for (final cfg in getRequiredFields()) cfg.field: cfg
  };

    final actions = <String, Dosage>{};


    // Extract numeric values from evaluator
    final a5Fibtem = evaluator.a5Fibtem;     // A5 FIBTEM
    final a5Extem = evaluator.a5Extem;       // A5 EXTEM
    final ctExtem = evaluator.ctExtem;       // CT EXTEM
    final ctIntem = evaluator.ctIntem;       // CT INTEM
    final ctFibtem = evaluator.ctFibtem;     // CT FIBTEM (make sure RotemEvaluator has this!)
    final mlExtem = evaluator.mlExtem;       // ML EXTEM




    //----------------------------------------------------------------------
    // 1) Fibrinogen if A5 FIBTEM < 12 mm
    //----------------------------------------------------------------------
      if (configs[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.low) {
    actions['Fibrinogen'] = Dosage(
      instruction: "Lågt fibrinogen",
      administrationRoute: "IV",
      lowerLimitDose: Dose.fromString(amount: 2, unit: "g"),
      higherLimitDose: Dose.fromString(amount: 4, unit: "g"),
    );
  }

    //----------------------------------------------------------------------
    // 2) Platelets if (A5 FIBTEM ≥ 12 mm) AND (A5 EXTEM < 35 mm)
    //----------------------------------------------------------------------

    if (configs[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.normal &&
        configs[RotemField.a5Extem]?.result(a5Extem) == Result.low) {
      actions['Trombocyter'] = Dosage(
        instruction: "Lågt trombocyter",
        administrationRoute: "IV",
        dose: Dose.fromString(amount: 1, unit: "E"),
      );
    }
        
    //----------------------------------------------------------------------
    // 3) Ocplex/Confidex 10E/kg eller plasma 10-15 ml/kg om (CT EXTEM > 80 s) OCH (A5 FIBTEM ≥ 12 mm)
    //----------------------------------------------------------------------
    if (configs[RotemField.ctExtem]?.result(ctExtem) == Result.high &&
        configs[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.normal) {
      actions['Ocplex/Plasma'] =
        Dosage(
          instruction: "Hög CT EXTEM och normal A5 FIBTEM - ge Ocplex/Confidex eller plasma",
          administrationRoute: "IV",
          lowerLimitDose: Dose.fromString(amount: 10, unit: "ml/kg"),
          higherLimitDose: Dose.fromString(amount: 15, unit: "ml/kg"),
        );
    }

    //----------------------------------------------------------------------
    // 4) Plasma if CT INTEM > 240 s
    //----------------------------------------------------------------------
    if (configs[RotemField.ctIntem]?.result(ctIntem) == Result.high) {
      actions['Plasma'] = 'CT INTEM > 240 s => Plasma 10 ml/kg';
    }

    //----------------------------------------------------------------------
    // 5) Cyklokapron if (CT FIBTEM > 600 s) OR (ML EXTEM > 10%)
    //----------------------------------------------------------------------
    if (configs[RotemField.ctFibtem]?.result(ctFibtem) == Result.high ||
        configs[RotemField.mlExtem]?.result(mlExtem) == Result.high) {
      actions['Cyklokapron'] = 'CT FIBTEM > 600 s eller ML EXTEM > 10% => Ge Cyklokapron';
    }

    return actions;
  }


  @override
  String? validateAll(Map<RotemField, String?> values) {


    // If no errors
    return null;
  }
}