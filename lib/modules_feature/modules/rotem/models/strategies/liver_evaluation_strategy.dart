import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';


class LiverFailureEvaluationStrategy extends RotemEvaluationStrategy {

  
  @override
  Map<String, String> evaluate(RotemEvaluator evaluator) {
    final actions = <String, String>{};

    // Quick lookup for FieldConfig by RotemField
    final fieldMap = {
      for (final cfg in getRequiredFields()) cfg.field: cfg
    };

    // Extract numeric values from evaluator
    final a5Fibtem = evaluator.a5Fibtem;      // A5 FIBTEM
    final a5Extem  = evaluator.a5Extem;       // A5 EXTEM
    final ctExtem  = evaluator.ctExtem;       // CT EXTEM
    final ctIntem  = evaluator.ctIntem;       // CT INTEM
    final mlExtem  = evaluator.mlExtem;       // ML EXTEM
    final li30Extem = evaluator.li30Extem;    // LI 30 EXTEM (Add to your RotemEvaluator if needed)

    //----------------------------------------------------------------------
    // 1) Fibrinogen if (A5 FIBTEM < 8) AND (A5 EXTEM < 25)
    //    Dose: 2 g, goal A5 FIBTEM >= 10 mm
    //----------------------------------------------------------------------
    if (a5Fibtem != null && a5Extem != null &&
        a5Fibtem < 8 && a5Extem < 25) 
    {
      actions['Fibrinogen'] = 
        'A5 FIBTEM < 8 mm och A5 EXTEM < 25 mm => Ge Fibrinogen 2 g (mål ≥ 10 mm)';
    }

    //----------------------------------------------------------------------
    // 2) Platelets if (A5 FIBTEM ≥ 8) AND (A5 EXTEM < 25)
    //----------------------------------------------------------------------
    if (a5Fibtem != null && a5Extem != null &&
        a5Fibtem >= 8 && a5Extem < 25)
    {
      actions['Trombocyter'] =
        'A5 FIBTEM ≥ 8 mm och A5 EXTEM < 25 mm => Ge trombocyter (1 E)';
    }

    //----------------------------------------------------------------------
    // 3) Ocplex/Confidex or Plasma if (CT EXTEM > 75) AND (A5 FIBTEM ≥ 8)
    //----------------------------------------------------------------------
    if (ctExtem != null && a5Fibtem != null &&
        ctExtem > 75 && a5Fibtem >= 8)
    {
      actions['Ocplex/Plasma'] =
        'CT EXTEM > 75 s och A5 FIBTEM ≥ 8 mm => '
        'Ocplex®/Confidex® 500 IE eller plasma 10–15 ml/kg';
    }

    //----------------------------------------------------------------------
    // 4) Plasma if CT INTEM > 280
    //----------------------------------------------------------------------
    if (ctIntem != null && ctIntem > 280) {
      actions['Plasma'] = 'CT INTEM > 280 s => Plasma 10 ml/kg';
    }

    //----------------------------------------------------------------------
    // 5) Cyklokapron if (ML EXTEM > 85) OR (LI 30 EXTEM > 50)
    //----------------------------------------------------------------------
    if ((mlExtem != null && mlExtem > 85) ||
        (li30Extem != null && li30Extem > 50)) 
    {
      actions['Cyklokapron'] =
        'ML EXTEM > 85% eller LI30 EXTEM > 50% => '
        'Ge Cyklokapron® 1–2 g (≈ 20 mg/kg)';
    }

    return actions;
  }

  @override
  List<FieldConfig> getRequiredFields() {
    return [
      // A5 FIBTEM: e.g. below 8 triggers fibrinogen
      FieldConfig(
        label: 'A5 FIBTEM',
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
        minValue: 8, // "Normal" floor is 8 for this protocol
      ),
      // A5 EXTEM: below 25 => platelets (or fibrinogen, depending on A5 FIBTEM)
      FieldConfig(
        label: 'A5 EXTEM',
        field: RotemField.a5Extem,
        section: RotemSection.extem,
        minValue: 25,
      ),
      // CT EXTEM: above 75 => Ocplex/Plasma
      FieldConfig(
        label: 'CT EXTEM',
        field: RotemField.ctExtem,
        section: RotemSection.extem,
        maxValue: 75,
      ),
      // CT INTEM: above 280 => Plasma
      FieldConfig(
        label: 'CT INTEM',
        field: RotemField.ctIntem,
        section: RotemSection.intem,
        maxValue: 280,
      ),
      // ML EXTEM: above 85 => Cyklokapron
      FieldConfig(
        label: 'ML EXTEM',
        field: RotemField.mlExtem,
        section: RotemSection.extem,
        maxValue: 85,
      ),
      // LI 30 EXTEM: above 50 => Cyklokapron
      // (Add a new RotemField.li30Extem if needed in your codebase)
      FieldConfig(
        label: 'LI 30 EXTEM',
        field: RotemField.li30Extem,  // You must define this in your RotemField enum
        section: RotemSection.extem,
        maxValue: 50,
      ),
    ];
  }

  @override
  String? validateAll(Map<RotemField, String?> values) {
    // Example validations:
    final a5FibtemVal = values[RotemField.a5Fibtem];
    final a5ExtemVal  = values[RotemField.a5Extem];
    final ctExtemVal  = values[RotemField.ctExtem];
    final ctIntemVal  = values[RotemField.ctIntem];
    final mlExtemVal  = values[RotemField.mlExtem];
    final li30Val     = values[RotemField.li30Extem];

    // If your UI requires all to be filled:
    if (a5FibtemVal == null || a5FibtemVal.isEmpty) {
      return 'A5 FIBTEM måste fyllas i.';
    }
    if (a5ExtemVal == null || a5ExtemVal.isEmpty) {
      return 'A5 EXTEM måste fyllas i.';
    }
    if (ctExtemVal == null || ctExtemVal.isEmpty) {
      return 'CT EXTEM måste fyllas i.';
    }
    if (ctIntemVal == null || ctIntemVal.isEmpty) {
      return 'CT INTEM måste fyllas i.';
    }
    if (mlExtemVal == null || mlExtemVal.isEmpty) {
      return 'ML EXTEM måste fyllas i.';
    }
    if (li30Val == null || li30Val.isEmpty) {
      return 'LI 30 EXTEM måste fyllas i.';
    }

    // No errors
    return null;
  }
}