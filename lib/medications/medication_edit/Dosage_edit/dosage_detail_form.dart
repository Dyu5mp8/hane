import "package:flutter/material.dart";
import "package:hane/medications/models/medication.dart";
import "package:hane/utils/unit_parser.dart";
import "package:hane/utils/validate_dosage_save.dart" as val;

class DosageDetailForm {
  late Dosage dosage;
  Function(Dosage) onSave;
  TextEditingController instructionController = TextEditingController();
  TextEditingController administrationRouteController = TextEditingController();

  TextEditingController doseAmountController = TextEditingController();
  TextEditingController doseUnitController = TextEditingController();

  TextEditingController lowerLimitDoseAmountController =
      TextEditingController();
  TextEditingController lowerLimitDoseUnitController = TextEditingController();

  TextEditingController higherLimitDoseAmountController =
      TextEditingController();
  TextEditingController higherLimitDoseUnitController = TextEditingController();

  TextEditingController maxDoseamountController = TextEditingController();
  TextEditingController maxDoseUnitController = TextEditingController();

  DosageDetailForm({Dosage? dosage, required this.onSave}) {
    this.dosage = dosage ?? Dosage(instruction: "");

    instructionController.text = this.dosage.instruction ?? "";
    administrationRouteController.text = this.dosage.administrationRoute ?? "";
    doseAmountController.text = this.dosage.dose?.amount.toString() ?? "";
    doseUnitController.text = this.dosage.dose?.unitString() ?? "";
    lowerLimitDoseAmountController.text =
        this.dosage.lowerLimitDose?.amount.toString() ?? "";
    lowerLimitDoseUnitController.text =
        this.dosage.lowerLimitDose?.unitString() ?? "";
    higherLimitDoseAmountController.text =
        this.dosage.higherLimitDose?.amount.toString() ?? "";
    higherLimitDoseUnitController.text =
        this.dosage.higherLimitDose?.unitString() ?? "";
    maxDoseamountController.text = this.dosage.maxDose?.amount.toString() ?? "";
    maxDoseUnitController.text = this.dosage.maxDose?.unitString() ?? "";
  }

  String? validateDosageFields(String? value) {
    var doseAmount = doseAmountController.text;
    var doseUnit = doseUnitController.text;
    var lowerLimitDoseAmount = lowerLimitDoseAmountController.text;
    var lowerLimitDoseUnit = lowerLimitDoseUnitController.text;
    var higherLimitDoseAmount = higherLimitDoseAmountController.text;
    var higherLimitDoseUnit = higherLimitDoseUnitController.text;

    bool isValidDose = val.validateAmountInput(doseAmount) == null &&
        val.validateUnitInput(doseUnit) == null;
    bool isValidLowerLimitDose =
        val.validateAmountInput(lowerLimitDoseAmount) == null &&
            val.validateUnitInput(lowerLimitDoseUnit) == null;
    bool isValidHigherLimitDose =
        val.validateAmountInput(higherLimitDoseAmount) == null &&
            val.validateUnitInput(higherLimitDoseUnit) == null;

    if (isValidDose || (isValidLowerLimitDose && isValidHigherLimitDose)) {
      return null;
    }

    return "Ange antingen ett giltig dos eller ett giltigt dosintervall";
  }

  Dose? createDose(String amount, String unit) {
    if (amount.isEmpty || unit.isEmpty) {
      return null;
    }
    return Dose(
        amount: UnitParser.normalizeDouble(amount),
        units: Dose.getDoseUnitsAsMap(unit));
  }

  void saveDosage() {
    var instruction =
        instructionController.text == "" ? null : instructionController.text;
    var administrationRoute = administrationRouteController.text == ""
        ? null
        : administrationRouteController.text;
    var dose = createDose(doseAmountController.text, doseUnitController.text);
    var lowerLimitDose = createDose(
        lowerLimitDoseAmountController.text, lowerLimitDoseUnitController.text);
    var higherLimitDose = createDose(higherLimitDoseAmountController.text,
        higherLimitDoseUnitController.text);
    var maxDose =
        createDose(maxDoseamountController.text, maxDoseUnitController.text);

    Dosage updatedDosage = Dosage(
      instruction: instruction,
      administrationRoute: administrationRoute,
      dose: dose,
      lowerLimitDose: lowerLimitDose,
      higherLimitDose: higherLimitDose,
      maxDose: maxDose,
    );
    onSave(updatedDosage);
  }
}
