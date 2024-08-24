import "package:flutter/material.dart";
import "package:hane/medications/models/medication.dart";
import "package:hane/utils/unit_service.dart";

class DosageViewHandler {
  final Dosage dosage;
  double? conversionWeight;
  String? conversionTime;
  Concentration? conversionConcentration;
  List<Concentration>? availableConcentrations;
  late ({bool weight, bool time, bool concentration}) ableToConvert;

  DosageViewHandler(Key? key,
      {required this.dosage,
      this.conversionWeight,
      this.conversionTime,
      this.conversionConcentration,
      this.availableConcentrations})
      {
    ableToConvert = _ableToConvert();  // Call to the instance method
  }

  bool canConvertConcentration (Dose dose){
  if (availableConcentrations != null && dose.units.containsKey("substance")) {
    var concentrationSubstanceUnits = availableConcentrations!
        .map((c) => UnitParser.getConcentrationsUnitsAsMap(c.unit)["substance"]);
    var concentrationUnitTypes = concentrationSubstanceUnits
        .map((c) => UnitValidator.getUnitType(c))
        .toSet();
    var doseUnitType = UnitValidator.getUnitType(dose.units["substance"]!);

    return concentrationUnitTypes.contains(doseUnitType);
  }
  return false;
  }

  bool canConvertTime(Dose dose) {
    return dose.units.containsKey("time");
  }

  bool canConvertWeight(Dose dose) {
    return dose.units.containsKey("patientWeight");
  } 

  ({bool weight, bool time, bool concentration}) _ableToConvert() {
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
        if(canConvertTime(dose)){
          timeConversions++;
        }

        if(canConvertWeight(dose)){
          weightConversions++;
        }

        if(canConvertConcentration(dose)){
          concentrationConversions++;
        }

    }
   
    }
     return (
      weight: weightConversions > 0,
      time: timeConversions > 0,
      concentration: concentrationConversions > 0
    );
  }

  Text showDosage() {
    bool shouldConvertDoses = (conversionWeight != null ||
        conversionTime != null ||
        conversionConcentration != null);

    Dose? convertIfNeeded(Dose? dose) {
      if (dose == null) return null;
      return shouldConvertDoses
          ? dose.convertedBy(
              convertWeight: canConvertWeight(dose) ? conversionWeight : null,
              convertTime: canConvertTime(dose) ? conversionTime : null,
              convertConcentration:   canConvertConcentration(dose) ? conversionConcentration : null,
            )
          : dose;
    }

    Dose? dose = convertIfNeeded(dosage.dose);
    Dose? lowerLimitDose = convertIfNeeded(dosage.lowerLimitDose);
    Dose? higherLimitDose = convertIfNeeded(dosage.higherLimitDose);
    Dose? maxDose = convertIfNeeded(dosage.maxDose);

    double _fontSize = 14;
    TextDecoration _decoration = shouldConvertDoses ? TextDecoration.underline : TextDecoration.none;
    
    TextSpan routeText(String route) {
      if (route.isEmpty) return TextSpan();
      return TextSpan(
        text: "$route.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,
        ),
      );
    }
    TextSpan instructionText(String instruction) {
      if (instruction.isEmpty) return TextSpan();
      return TextSpan(
        text: "$instruction:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,

        
        ),
      );
    }

    TextSpan doseText(Dose? dose) {
      if (dose == null) return TextSpan();
      return TextSpan(
        text: "${dose.toString()}.",
        style: TextStyle(
          fontSize: _fontSize,
        decoration: _decoration,

        ),
      );
    }

 

    TextSpan doseRangeText(Dose? lowerLimitDose, Dose? higherLimitDose) {
      if (lowerLimitDose == null || higherLimitDose == null) return TextSpan();
      return TextSpan(
        text: "(${lowerLimitDose.toString()} - ${higherLimitDose.toString()}).",
        style: TextStyle(
          fontSize: _fontSize,
          decoration: _decoration,
        ),
      );
    }


    TextSpan maxDoseText(Dose? maxDose) {
      if (maxDose == null) return TextSpan();
      return TextSpan(
        text: "Maxdos: ${maxDose.toString()}.",
        style: TextStyle(
          fontSize: _fontSize,
          decoration: _decoration,
        ),
      );
    } 

   TextSpan space() {
      return TextSpan(
        text: " ",
        style: TextStyle(
          fontSize: _fontSize,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          routeText(dosage.administrationRoute ?? ''),
          space(),
          instructionText(dosage.instruction ?? ''),
          space(),
          doseText(dose),
          space(),
          doseRangeText(lowerLimitDose, higherLimitDose),
          space(),
          maxDoseText(maxDose),
        ],

      
      ),
    );
  }
}
