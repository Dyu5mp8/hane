import "package:flutter/material.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/utils/unit_service.dart";
import "package:hane/utils/smart_rounder.dart";
import "package:flutter/foundation.dart";

enum AdministrationRoute {
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
  Dosage dosage;
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
    if (availableConcentrations != null &&
        dose.units.containsKey("substance")) {
      var concentrationSubstanceUnits = availableConcentrations!.map(
          (c) => UnitParser.getConcentrationsUnitsAsMap(c.unit)["substance"]);
      var concentrationUnitTypes = concentrationSubstanceUnits
          .map((c) => UnitValidator.getUnitType(c))
          .toSet();
      var doseUnitType = UnitValidator.getUnitType(dose.units["substance"]!);

      return concentrationUnitTypes.contains(doseUnitType);
    }
    return false;
  }

  void setNewDosage(Dosage dosage) {
    this.dosage = dosage;
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
    TextSpan buildDosageTextSpan({
      String? conversionInfo,
      required String? instruction,
      required Dose? dose,
      required Dose? lowerLimitDose,
      required Dose? higherLimitDose,
      required Dose? maxDose,
      required bool shouldConvertDoses,
    }) {
      final TextSpan instructionSpan = TextSpan(
        text: instruction != null && instruction.isNotEmpty
            ? "${instruction.trimRight()}${RegExp(r'[.,:]$').hasMatch(instruction) ? '' : ':'} "
            : '',
      );
      final TextSpan doseSpan = TextSpan(
        text: dose != null ? "$dose. " : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );

      TextSpan doseRangeSpan() {
        if (lowerLimitDose != null && higherLimitDose != null) {
          if (dose != null) {
            return TextSpan(
              text: "($lowerLimitDose - $higherLimitDose). ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          } else {
            return TextSpan(
              text: "$lowerLimitDose. - $higherLimitDose. ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          }
        }
        return const TextSpan(text: "");
      }

      final TextSpan maxDoseSpan = TextSpan(
        text: maxDose != null ? "Maxdos: ${maxDose.scaleDose()}." : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );

      return TextSpan(
        children: [
          if (conversionInfo != null && conversionInfo.isNotEmpty)
            TextSpan(
              text: conversionInfo,
              style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.italic),
            ),
          instructionSpan,
          doseSpan,
          doseRangeSpan(),
          maxDoseSpan,
        ],
      );
    }

    if (isOriginalText) {
      return Text.rich(
        TextSpan(
          text: '',
          children: [
            buildDosageTextSpan(
              conversionInfo: '',
              instruction: dosage.instruction,
              dose: dosage.dose,
              lowerLimitDose: dosage.lowerLimitDose,
              higherLimitDose: dosage.higherLimitDose,
              maxDose: dosage.maxDose,
              shouldConvertDoses: false,
            ),
          ],
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
                convertConcentration: canConvertConcentration(dose)
                    ? conversionConcentration
                    : null,
              )
            : dose;
      }

      Map<String, String> unitsExcludingWeight(Map<String, String> units) {
        return Map.from(units)..remove('patientWeight');
      }

      Dose? maxDose = convertIfNeeded(dosage.maxDose);

      Dose? clampDoseIfExceedsMax(Dose? dose) {
        if (dose != null && maxDose != null) {
          var maxDoseUnits = unitsExcludingWeight(maxDose.units);
          // Use setEquals to compare the key sets
          if (setEquals(dose.units.keys.toSet(), maxDoseUnits.keys.toSet())) {
            if (dose.compareTo(maxDose) > 0) {
              // Return maxDose if dose exceeds maxDose
              return maxDose;
            } else {
              return dose;
            }
          } else {
            return dose;
          }
        }
        return dose;
      }

      Dose? dose = clampDoseIfExceedsMax(convertIfNeeded(dosage.dose));
      Dose? lowerLimitDose =
          clampDoseIfExceedsMax(convertIfNeeded(dosage.lowerLimitDose));
      Dose? higherLimitDose =
          clampDoseIfExceedsMax(convertIfNeeded(dosage.higherLimitDose));

      // check for maxdose, and if the units match the converted higherLimitDose it will clamp the higherLimitDose to the maxDose

      String? weightConversionInfo = conversionWeight != null
          ? "vikt ${smartRound(conversionWeight!).toString()} kg"
          : null;

      String? concentrationConversionInfo = conversionConcentration != null
          ? "styrka ${conversionConcentration.toString()}"
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
          ? "Beräknat på ${conversionParts.join(', ')}:\n"
          : "";

      return Text.rich(
        TextSpan(
          children: [
            buildDosageTextSpan(
              conversionInfo: conversionInfo,
              instruction: dosage.instruction,
              dose: dose,
              lowerLimitDose: lowerLimitDose,
              higherLimitDose: higherLimitDose,
              maxDose: maxDose,
              shouldConvertDoses: shouldConvertDoses,
            ),
          ],
          style: const TextStyle(fontSize: 14),
        ),
      );
    }
  }

  String? getCommonUnitSymbol() {
    if (dosage.dose != null) {
      return dosage.dose!.substanceUnitString();
    } else if (dosage.lowerLimitDose != null) {
      return dosage.lowerLimitDose!.substanceUnitString();
    } else if (dosage.higherLimitDose != null) {
      return dosage.higherLimitDose!.substanceUnitString();
    }
    return null;
  }
}
