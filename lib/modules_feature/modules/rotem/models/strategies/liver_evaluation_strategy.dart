import 'package:hane/drugs/drug_detail/dosage_view_handler.dart';
import 'package:hane/drugs/models/administration_route.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/drugs/models/drug.dart';

class LiverFailureEvaluationStrategy extends RotemEvaluationStrategy {
  @override
  String get name => "Leversvikt";

  @override
  Map<String, List<RotemAction>> evaluate(RotemEvaluator evaluator) {
    final actions = <String, List<RotemAction>>{};

    // Quick lookup for FieldConfig by RotemField
    final fieldMap = {for (final cfg in getRequiredFields()) cfg.field: cfg};

    // Extract numeric values from evaluator
    final a5Fibtem = evaluator.a5Fibtem;
    final a5Extem = evaluator.a5Extem;
    final ctExtem = evaluator.ctExtem;
    final ctIntem = evaluator.ctIntem;
    final mlExtem = evaluator.mlExtem;
    final li30Extem = evaluator.li30Extem;
    final ctHeptem = evaluator.ctHeptem;

    //----------------------------------------------------------------------
    // 1) Fibrinogen if (A5 FIBTEM < 8) AND (A5 EXTEM < 25)
    //----------------------------------------------------------------------
    if (fieldMap[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.low) {
      actions['Lågt fibrinogen'] = [
        RotemAction(
          dosage: Dosage(
            instruction: "Riastap eller fibryga. Mål är A5 FIBTEM ≥ 10 mm.",
            administrationRoute: AdministrationRoute.iv,
            dose: Dose.fromString(2, "g"),
          ),
        ),
      ];
    }

    //----------------------------------------------------------------------
    // 2) Platelets if (A5 FIBTEM ≥ 8) AND (A5 EXTEM < 25)
    //----------------------------------------------------------------------
    if (fieldMap[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.normal &&
        fieldMap[RotemField.a5Extem]?.result(a5Extem) == Result.low) {
      actions['Trombocyter'] = [
        RotemAction(
          dosage: Dosage(
            instruction: "Behov av trombocyter",
            administrationRoute: AdministrationRoute.iv,
            dose: Dose.fromString(1, "E"),
          ),
        ),
      ];
    }

    //----------------------------------------------------------------------
    // 3) Ocplex/Confidex or Plasma if (CT EXTEM > 75) AND (A5 FIBTEM ≥ 8)
    //----------------------------------------------------------------------
    if (fieldMap[RotemField.ctExtem]?.result(ctExtem) == Result.high &&
        fieldMap[RotemField.a5Fibtem]?.result(a5Fibtem) == Result.normal) {
      actions['Hög CT EXTEM och normal A5 FIBTEM'] = [
        RotemAction(
          dosage: Dosage(
            instruction: "Plasma",
            administrationRoute: AdministrationRoute.iv,
            lowerLimitDose: Dose.fromString(10, "ml/kg"),
            higherLimitDose: Dose.fromString(15, "ml/kg"),
          ),
        ),
        RotemAction(
          dosage: Dosage(
            instruction: "Confidex/PCC",
            administrationRoute: AdministrationRoute.iv,
            dose: Dose.fromString(500, "E"),
          ),
        ),
      ];
    }

    //----------------------------------------------------------------------
    // 4) Plasma if CT INTEM > 280
    //----------------------------------------------------------------------
    if (fieldMap[RotemField.ctIntem]?.result(ctIntem) == Result.high) {
      actions['CT INTEM > 280 s'] = [
        RotemAction(
          dosage: Dosage(
            instruction: "Plasma",
            administrationRoute: AdministrationRoute.iv,
            dose: Dose.fromString(10, "ml/kg"),
          ),
        ),
      ];
    }

    //----------------------------------------------------------------------
    // 5) Cyklokapron if (ML EXTEM > 85) OR (LI 30 EXTEM > 50)
    //----------------------------------------------------------------------
    if (fieldMap[RotemField.mlExtem]?.result(mlExtem) == Result.high ||
        fieldMap[RotemField.li30Extem]?.result(li30Extem) == Result.high) {
      actions['ML EXTEM > 85% eller LI30 EXTEM > 50%'] = [
        RotemAction(
          dosage: Dosage(
            instruction: "Cyklokapron",
            administrationRoute: AdministrationRoute.iv,
            lowerLimitDose: Dose.fromString(1, "g"),
            higherLimitDose: Dose.fromString(2, "g"),
          ),
        ),
      ];
    }

    // 5) Protamin if CT INTEM > CT HEPTEM
    if (ctIntem != null &&
        ctHeptem != null &&
        ctIntem / ctHeptem > heptemCutoff) {
      actions['Protamin'] = [
        RotemAction(
          dosage: Dosage(
            administrationRoute: AdministrationRoute.iv,
            instruction: "Ge protamin",
            lowerLimitDose: Dose.fromString(50, "mg"),
          ),
        ),
      ];
    }

    return actions;
  }

  @override
  List<FieldConfig> getRequiredFields() {
    return [
      const FieldConfig(
        label: 'A5 FIBTEM',
        field: RotemField.a5Fibtem,
        section: RotemSection.fibtem,
        minValue: 8,
      ),
      const FieldConfig(
        label: 'A5 EXTEM',
        field: RotemField.a5Extem,
        section: RotemSection.extem,
        minValue: 25,
      ),
      const FieldConfig(
        label: 'CT EXTEM',
        field: RotemField.ctExtem,
        section: RotemSection.extem,
        maxValue: 75,
      ),
      const FieldConfig(
        label: 'CT INTEM',
        field: RotemField.ctIntem,
        section: RotemSection.intem,
        maxValue: 280,
        isRequired: false,
      ),
      const FieldConfig(
        label: 'ML EXTEM',
        field: RotemField.mlExtem,
        section: RotemSection.extem,
        maxValue: 85,
        isRequired: false,
      ),
      const FieldConfig(
        label: 'LI 30 EXTEM',
        field: RotemField.li30Extem,
        section: RotemSection.extem,
        maxValue: 50,
        isRequired: false,
      ),
      // add CT HEPTEM HERE IF NECESSARY
    ];
  }

  @override
  String? validateAll(Map<RotemField, String?> values) {
    final a5FibtemVal = values[RotemField.a5Fibtem];
    final a5ExtemVal = values[RotemField.a5Extem];
    final ctExtemVal = values[RotemField.ctExtem];

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
