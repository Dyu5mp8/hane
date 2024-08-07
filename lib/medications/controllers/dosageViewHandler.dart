import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
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
          var concentrationSubstanceUnits = availableConcentrations!
              .map((c) => UnitParser.getConcentrationsUnitsAsMap(c.unit)["substance"]);

          
          var concentrationUnitTypes = concentrationSubstanceUnits
              .map((c) => UnitValidator.getUnitType(c)).toSet();
          
          if (dose.units.containsKey("substance")) {
           
          

          var doseUnitType = UnitValidator.getUnitType(dose.units["substance"]!) ;  



          if (concentrationUnitTypes.contains(doseUnitType)) {
     
            concentrationConversions++;
          }

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

  Text showDosage() {
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

    double _fontSize = 14;
    TextDecoration _decoration = shouldConvertDoses ? TextDecoration.underline : TextDecoration.none;

    TextSpan instructionSpan(String instruction) {
      if (instruction.isEmpty) return TextSpan();
      return TextSpan(
        text: "$instruction:  ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize,

        
        ),
      );
    }

    TextSpan doseSpan(Dose? dose) {
      if (dose == null) return TextSpan();
      return TextSpan(
        text: dose.toString(),
        style: TextStyle(
          fontSize: _fontSize,
        decoration: _decoration,

        ),
      );
    }

    TextSpan doseRangeSpan(Dose? lowerLimitDose, Dose? higherLimitDose) {
      if (lowerLimitDose == null || higherLimitDose == null) return TextSpan();
      return TextSpan(
        text: " (${lowerLimitDose.toString()} - ${higherLimitDose.toString()})",
        style: TextStyle(
          fontSize: _fontSize,
          decoration: _decoration,
        ),
      );
    }


    TextSpan maxDoseSpan(Dose? maxDose) {
      if (maxDose == null) return TextSpan();
      return TextSpan(
        text: " Max dose: ${maxDose.toString()}",
        style: TextStyle(
          fontSize: _fontSize,
          decoration: _decoration,
        ),
      );
    } 

    TextSpan routeSpan(String route) {
      if (route.isEmpty) return TextSpan();
      return TextSpan(
        text: " $route",
        style: TextStyle(
          fontSize: _fontSize,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          instructionSpan(dosage.instruction ?? ''),
          doseSpan(dose),
          doseRangeSpan(lowerLimitDose, higherLimitDose),
          maxDoseSpan(maxDose),
          routeSpan(dosage.administrationRoute ?? ''),
        ],

      
      ),
    );
  }
}
