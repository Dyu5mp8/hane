import "package:flutter/material.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/utils/unit_service.dart";
import "package:hane/utils/smart_rounder.dart";

enum AdministrationRoute{

  po,
  iv,
  im,
  sc,
  rect,
  inh,
  nasal,
  other,
}

class DosageViewHandler {
  final Dosage dosage;
  double? conversionWeight;
  String? conversionTime;
  Concentration? conversionConcentration;
  List<Concentration>? availableConcentrations;
  late ({bool weight, bool time, bool concentration}) ableToConvert;

  DosageViewHandler(
    Key? key, {
    required this.dosage,
    this.conversionWeight,
    this.conversionTime,
    this.conversionConcentration,
    this.availableConcentrations,
  }) {
    ableToConvert = _ableToConvert();
  }

  bool canConvertConcentration(Dose dose) {
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
      dosage.maxDose,
    ];

    for (Dose? dose in doseList) {
      if (dose != null) {
        if (canConvertTime(dose)) {
          timeConversions++;
        }

        if (canConvertWeight(dose)) {
          weightConversions++;
        }

        if (canConvertConcentration(dose)) {
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

  AdministrationRoute? getAdministrationRoute() {
    switch (dosage.administrationRoute) {
      case "PO":
        return AdministrationRoute.po;
      case "IV":
        return AdministrationRoute.iv;
      case "IM":
        return AdministrationRoute.im;
      case "SC":
        return AdministrationRoute.sc;
      case "Nasalt":
        return AdministrationRoute.nasal;
      case "Inh": 
        return AdministrationRoute.inh;
      default:
        return AdministrationRoute.other;
      
  
    }
  }

  Text showDosage({required bool isOriginalText}) {
    String buildDosageText({
      String? conversionInfo,
      required String? route,
      required String? instruction,
      required Dose? dose,
      required Dose? lowerLimitDose,
      required Dose? higherLimitDose,
      required Dose? maxDose,
      required bool shouldConvertDoses,
    }) {
      final String conversionText = conversionInfo != null && conversionInfo.isNotEmpty
          ? conversionInfo
          : '';
      
      final String routeText = route != null && route.isNotEmpty
          ? "$route. "
          : '';

      final String instructionText = instruction != null && instruction.isNotEmpty
          ? "$instruction: "
          : '';

      final String doseText = dose != null
          ? "${dose.toString()}. "
          : '';

      String doseRangeText () {
       if (lowerLimitDose != null && higherLimitDose != null) {
         if (dose != null) {
           return "(${lowerLimitDose.toString()} - ${higherLimitDose.toString()}). ";
           }

         else {
            return "${lowerLimitDose.toString()} - ${higherLimitDose.toString()}. ";
         }
       }
          return "";
      }

      final String maxDoseText = maxDose != null
          ? "Maxdos: ${maxDose.toString()}."
          : '';

      return "$conversionText$routeText$instructionText$doseText${doseRangeText()}$maxDoseText";
    }

    if (isOriginalText) {
      return Text.rich(
        TextSpan(
          text: buildDosageText(
            conversionInfo: '',
            route: dosage.administrationRoute,
            instruction: dosage.instruction,
            dose: dosage.dose,
            lowerLimitDose: dosage.lowerLimitDose,
            higherLimitDose: dosage.higherLimitDose,
            maxDose: dosage.maxDose,
            shouldConvertDoses: false,
          ),
          style: const TextStyle(fontSize: 14),
        ),
      );
    } else {
      bool shouldConvertDoses = conversionWeight != null ||
          conversionTime != null ||
          conversionConcentration != null;

      Dose? convertIfNeeded(Dose? dose) {
        if (dose == null) return null;
        return shouldConvertDoses
            ? dose.convertedBy(
                convertWeight: canConvertWeight(dose) ? conversionWeight : null,
                convertTime: canConvertTime(dose) ? conversionTime : null,
                convertConcentration: canConvertConcentration(dose) ? conversionConcentration : null,
              )
            : dose;
      }

      Dose? dose = convertIfNeeded(dosage.dose);
      Dose? lowerLimitDose = convertIfNeeded(dosage.lowerLimitDose);
      Dose? higherLimitDose = convertIfNeeded(dosage.higherLimitDose);
      Dose? maxDose = convertIfNeeded(dosage.maxDose);

      String? weightConversionInfo = conversionWeight != null
        ? "vikt ${smartRound(conversionWeight!).toString()} kg"
        : null;

      String? concentrationConversionInfo = conversionConcentration != null
        ? "koncentration ${conversionConcentration.toString()}"
        : null;

      String? timeConversionInfo = conversionTime != null
        ? "tidsenhet ${conversionTime.toString()}"
        : null;

      List<String> conversionParts = [
        if (weightConversionInfo != null) weightConversionInfo,
        if (concentrationConversionInfo != null) concentrationConversionInfo,
        if (timeConversionInfo != null) timeConversionInfo,
      ];

      String conversionInfo = conversionParts.isNotEmpty
        ? "Konvertering baserat på ${conversionParts.join(', ')}: "
        : "";

      return Text.rich(
        TextSpan(
          children: [
            if (conversionInfo.isNotEmpty)
              TextSpan(
                text: '\n', // Newline before conversion info
              ),
            if (conversionInfo.isNotEmpty)
              TextSpan(
                text: conversionInfo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            if (conversionInfo.isNotEmpty)
              TextSpan(
                text: '\n', // Newline after conversion info
              ),
            TextSpan(
              text: buildDosageText(
                conversionInfo: '',
                route: null,
                instruction: dosage.instruction,
                dose: dose,
                lowerLimitDose: lowerLimitDose,
                higherLimitDose: higherLimitDose,
                maxDose: maxDose,
                shouldConvertDoses: shouldConvertDoses,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }
  }
}