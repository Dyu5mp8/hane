import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/administration_route.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/unit_service.dart';
import 'package:hane/utils/smart_rounder.dart';
import 'package:flutter/foundation.dart';
import 'package:hane/drugs/models/units.dart';

class DosageViewHandler extends ChangeNotifier {
  Dosage dosage;
  double? _conversionWeight;
  TimeUnit? _conversionTime;
  Concentration? _conversionConcentration;
  List<Concentration>? availableConcentrations;
  Function()? onDosageUpdated;
  Function()? onDosageDeleted;  

  DosageViewHandler({
    Key? key,
    required this.dosage,

    double? conversionWeight,
    TimeUnit? conversionTime,
    Concentration? conversionConcentration,
    this.availableConcentrations,
    this.onDosageDeleted, 
    this.onDosageUpdated, 
  })  : _conversionWeight = conversionWeight,
        _conversionTime = conversionTime,
        _conversionConcentration = conversionConcentration;        


  double? get conversionWeight => _conversionWeight;
  TimeUnit? get conversionTime => _conversionTime;
  Concentration? get conversionConcentration => _conversionConcentration;

  set conversionWeight(double? value) {
    _conversionWeight = value;
    notifyListeners();
  }

  set conversionTime(TimeUnit? value) {
    _conversionTime = value;
    notifyListeners();
  }

  set conversionConcentration(Concentration? value) {
    _conversionConcentration = value;
    notifyListeners();
  }

  /// Returns a list of concentrations that can be used for conversion,
  /// filtering by the unit type of the dose’s substance unit.
  List<Concentration>? get convertibleConcentrations {
    final SubstanceUnit? doseSubstanceUnit = dosage.dose?.substanceUnit;
    if (doseSubstanceUnit != null && availableConcentrations != null) {
      final filtered = availableConcentrations!
          .where((c) => c.substance.unitType == doseSubstanceUnit.unitType)
          .toList();
      return filtered.isNotEmpty ? filtered : null;
    }
    return null;
  }

  /// Checks if the given dose can be converted via concentration.
  bool canConvertConcentration() {
    Dose? dose = dosage.dose;
    if (availableConcentrations == null) return false;
    final doseUnitType = dose?.substanceUnit.unitType;
    if (doseUnitType == null) return false;
    final concentrationUnitTypes =
        availableConcentrations!.map((c) => c.substance.unitType).toSet();
    return concentrationUnitTypes.contains(doseUnitType);
  }

  /// Returns true if the dose has a non-null time unit.
  bool canConvertTime() => dosage.dose?.timeUnit != null;

  /// Returns true if the dose has a non-null weight unit.
  bool canConvertWeight() => dosage.dose?.weightUnit != null;

  Dose? doseForDisplay(Dose? dose) {
    var displayDose = dose;

    displayDose = displayDose
        ?.convertByWeight(conversionWeight?.toInt())
        .convertByConcentration(conversionConcentration)
        .convertByTime(conversionTime);

    if (dosage.maxDose != null &&
        displayDose != null &&
        displayDose > dosage.maxDose!) {
      displayDose = dosage.maxDose;
    }
    displayDose = displayDose?.scaleAmount().roundAmount();

    return displayDose;
  }

  Dose? get dose => doseForDisplay(dosage.dose);
  Dose? get lowerLimitDose => doseForDisplay(dosage.lowerLimitDose);
  Dose? get higherLimitDose => doseForDisplay(dosage.higherLimitDose);
  Dose? get maxDose => dosage.maxDose?.roundAmount();

  /// Builds and returns a Text widget showing the dosage.
  /// If [isOriginalText] is true, it shows the original text;
  /// otherwise, it converts the doses according to the conversion values.
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
      final instructionSpan = TextSpan(
        text: (instruction != null && instruction.isNotEmpty)
            ? "${instruction.trimRight()}${RegExp(r'[.,:]$').hasMatch(instruction) ? '' : ':'} "
            : '',
      );

      final doseSpan = TextSpan(
        text: dose != null ? "$dose. " : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );

      TextSpan doseRangeSpan() {
        if (lowerLimitDose != null && higherLimitDose != null) {
          return TextSpan(
            text: "($lowerLimitDose - $higherLimitDose). ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        }
        return const TextSpan(text: "");
      }

      final maxDoseSpan = TextSpan(
        text: maxDose != null ? "Maxdos: $maxDose." : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );

      return TextSpan(
        children: [
          if (conversionInfo != null && conversionInfo.isNotEmpty)
            TextSpan(
              text: conversionInfo,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          instructionSpan,
          doseSpan,
          doseRangeSpan(),
          maxDoseSpan,
        ],
      );
    }

    // If showing original text, simply build the dosage text span with no conversion info.
    if (isOriginalText) {
      return Text.rich(
        TextSpan(
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
      // Helper: convert dose if needed.
      Dose? convertIfNeeded(Dose? dose) {
        if (dose == null) return null;
        var converted = dose;
        if (conversionWeight != null) {
          converted = converted.convertByWeight(conversionWeight!.toInt());
        }
        if (conversionConcentration != null) {
          converted =
              converted.convertByConcentration(conversionConcentration!);
        }
        if (conversionTime != null) {
          converted =
              converted.convertByTime(TimeUnit.fromString(conversionTime!));
        }
        return converted;
      }

      // Helper: clamp the dose to the max dose if the units match and the dose exceeds the max.
      Dose? clampDoseIfExceedsMax(Dose? dose) {
        if (dose == null || dosage.maxDose == null) return dose;
        final maxDose = dosage.maxDose!;
        if (dose.substanceUnit.unitType == maxDose.substanceUnit.unitType &&
            dose.amount > maxDose.amount) {
          return maxDose;
        }
        return dose;
      }

      final convertedDose = clampDoseIfExceedsMax(convertIfNeeded(dosage.dose));
      final convertedLowerLimitDose =
          clampDoseIfExceedsMax(convertIfNeeded(dosage.lowerLimitDose));
      final convertedHigherLimitDose =
          clampDoseIfExceedsMax(convertIfNeeded(dosage.higherLimitDose));
      final convertedMaxDose = convertIfNeeded(dosage.maxDose);

      final weightConversionInfo = conversionWeight != null
          ? "vikt ${smartRound(conversionWeight!).toString()} kg"
          : null;
      final concentrationConversionInfo = conversionConcentration != null
          ? "styrka ${conversionConcentration.toString()}"
          : null;
      final timeConversionInfo = conversionTime != null
          ? "tidsenhet ${conversionTime.toString()}"
          : null;

      final conversionParts = [
        if (weightConversionInfo != null) weightConversionInfo,
        if (concentrationConversionInfo != null) concentrationConversionInfo,
        if (timeConversionInfo != null) timeConversionInfo,
      ];
      final conversionInfo = conversionParts.isNotEmpty
          ? "Beräknat på ${conversionParts.join(', ')}:\n"
          : "";

      return Text.rich(
        TextSpan(
          children: [
            buildDosageTextSpan(
              conversionInfo: conversionInfo,
              instruction: "",
              dose: convertedDose,
              lowerLimitDose: convertedLowerLimitDose,
              higherLimitDose: convertedHigherLimitDose,
              maxDose: convertedMaxDose,
              shouldConvertDoses: true,
            ),
          ],
          style: const TextStyle(fontSize: 14),
        ),
      );
    }
  }

  /// Returns the common unit symbol (here using unitType) from the current dose.
  String? getCommonUnitSymbol() {
    return dosage.dose?.substanceUnit.unitType;
  }
}
