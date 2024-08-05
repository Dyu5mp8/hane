import "package:flutter/foundation.dart";
import "package:hane/medications/models/medication.dart";
import "package:hane/utils/UnitParser.dart";
import "package:hane/utils/UnitService.dart";

class DosageViewHandler {
  final Dosage dosage;
  double? conversionWeight;
  String? conversionTime;
  Concentration? conversionConcentration;
  List<Concentration>? availableConcentrations;

  DosageViewHandler(Key? key,
      {required this.dosage,
      this.conversionWeight,
      this.conversionTime,
      this.conversionConcentration,
      this.availableConcentrations});

  ({bool weight, bool time, bool concentration}) ableToConvert() {
    int weightConversions = 0;
    int timeConversions = 0;
    int concentrationConversions = 0;

    List<Dose?> doseList = [
      dosage.dose,
      dosage.lowerLimitDose,
      dosage.higherLimitDose,
      dosage.maxDose
    ];

    for (Dose? dose in doseList) {
      if (dose != null) {
        if (dose.units.containsKey("time")) {
          timeConversions++;
        }

        if (dose.units.containsKey("patientWeight")) {
          weightConversions++;
        }

        if (availableConcentrations != null) {
          var concentrationSubstanceUnits = availableConcentrations!.map(
              (conc) => UnitParser.getConcentrationsUnitsAsMap(
                  conc.unit)["substance"]);
          if (concentrationSubstanceUnits.contains(dose.units["substance"])) {
            concentrationConversions++;
          }
        }
      }
    }

    return (
      weight: weightConversions > 0,
      time: timeConversions > 0,
      concentration: concentrationConversions > 0
    );
  }

  void setConversionWeight(double weight) {
    conversionWeight = weight;
  }

  String showDosage() {
    bool shouldConvertDoses = (conversionWeight != null ||
        conversionTime != null ||
        conversionConcentration != null);

    Dose? convertIfNeeded(Dose? dose) {
      if (dose == null) return null;
      return shouldConvertDoses
          ? dose.convertedBy(
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
      doseString.write(dose.toString());
    }
    if (lowerLimitDose != null && higherLimitDose != null) {
      if (doseString.isNotEmpty) doseString.write(" (");
      doseString.write(
          "${lowerLimitDose.toString()} - ${higherLimitDose.toString()}");
      if (doseString.toString().contains("(")) doseString.write(")");
    }

    String result =
        "${doseString.toString()} ${dosage.administrationRoute ?? ''}.".trim();

    if (maxDose != null) {
      result += " Max dose: ${maxDose.toString()}.";
    }

    return result;
  }
}
