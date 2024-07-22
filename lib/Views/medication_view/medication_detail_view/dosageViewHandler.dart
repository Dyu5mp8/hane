import "dart:ffi";
import "package:flutter/foundation.dart";
import "package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart";
import "package:hane/models/medication/bolus_dosage.dart";
import "package:hane/models/medication/dose.dart";
import "package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart";



 class DosageViewHandler {
  final Dosage dosage;
  double? conversionWeight;
  String? conversionTime;
  ({double amount, String unit})? conversionConcentration;


  DosageViewHandler(Key? key, {
  
    required this.dosage,
    this.conversionWeight,
    this.conversionTime,
    this.conversionConcentration,
  });

  String showDosage() {
    bool shouldConvertDoses = (conversionWeight != null || conversionTime != null || conversionConcentration != null);

    Dose? convertIfNeeded(Dose? dose) {
      if (dose == null) return null;
      return shouldConvertDoses
          ? DoseConverter.convertDose(
              dose: dose,
              convertWeight: conversionWeight,
              convertTime: conversionTime,
              convertConcentration: conversionConcentration,
            )
          : dose;
    }

    Dose? dose = convertIfNeeded(dosage.dose);
    Dose? lowerLimitDose = convertIfNeeded(dosage.lowerLimitDose);
    Dose? higherLimitDose = convertIfNeeded(dosage.higherLimitDose);
    Dose? maxDose = convertIfNeeded(dosage.maxDose);

    StringBuffer doseString = StringBuffer();
    if (dosage.instruction != null) {
      doseString.write(dosage.instruction);
    }
    if (dose != null) {
      if (doseString.isNotEmpty) doseString.write(": ");
      doseString.write("${dose.amount} ${dose.unit}");
    }
    if (lowerLimitDose != null && higherLimitDose != null) {
      if (doseString.isNotEmpty) doseString.write(" (");
      doseString.write("${lowerLimitDose.amount} ${lowerLimitDose.unit} - ${higherLimitDose.amount} ${higherLimitDose.unit}");
      if (doseString.toString().contains("(")) doseString.write(")");
    }

    String result = "${doseString.toString()} ${dosage.administrationRoute ?? ''}.".trim();

    if (maxDose != null) {
      result += " Max dose: ${maxDose.amount} ${maxDose.unit}.";
    }

    return result;
  }
}