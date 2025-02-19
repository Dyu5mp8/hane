import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/extensions/round_dose.dart';
import 'package:flutter/foundation.dart';
import 'package:hane/drugs/models/units.dart';

class DosageViewHandler extends ChangeNotifier {
  Dosage dosage;
  double? _conversionWeight;
  TimeUnit? _conversionTime;
  Concentration? _conversionConcentration;
  List<Concentration>? availableConcentrations;

  Function()? onDosageDeleted;
  final Function(Dosage) onDosageUpdated;

  DosageViewHandler({
    Key? key,
    required this.dosage,
    double? conversionWeight,
    TimeUnit? conversionTime,
    Concentration? conversionConcentration,
    this.availableConcentrations,
    this.onDosageDeleted,
    required this.onDosageUpdated,
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

  get conversionActive =>
      conversionWeight != null ||
      conversionTime != null ||
      conversionConcentration != null;

  /// Returns a list of concentrations that can be used for conversion,
  /// filtering by the unit type of the dose’s substance unit.
  List<Concentration>? get convertibleConcentrations {
    final SubstanceUnit? doseSubstanceUnit = dosage.getSubstanceUnit();
    if (doseSubstanceUnit != null && availableConcentrations != null) {
      final filtered = availableConcentrations!
          .where((c) => c.substance.unitType == doseSubstanceUnit.unitType)
          .toList();
      return filtered.isNotEmpty ? filtered : null;
    }
    return null;
  }

  void deleteDosage() {
    onDosageDeleted?.call();
  }

  void updateDosage(Dosage updatedDosage) {
    onDosageUpdated(updatedDosage);
  }

  /// Checks if the given dose can be converted via concentration.
  bool canConvertConcentration() {
    final doseUnitType = dosage.getSubstanceUnit();
    return availableConcentrations
            ?.any((c) => c.substance.unitType == doseUnitType?.unitType) ??
        false;
  }

  /// Returns true if the dose has a non-null time unit.
  bool canConvertTime() =>
      dosage.dose?.timeUnit != null ||
      dosage.lowerLimitDose?.timeUnit != null ||
      dosage.higherLimitDose?.timeUnit != null ||
      dosage.maxDose?.timeUnit != null;

  /// Returns true if the dose has a non-null weight unit.
  bool canConvertWeight() =>
      dosage.dose?.weightUnit != null ||
      dosage.lowerLimitDose?.weightUnit != null ||
      dosage.higherLimitDose?.weightUnit != null ||
      dosage.maxDose?.weightUnit != null;



  Dose? originalDose(Dose? dose) {
    return dose;
  }

  Dose? convertedDose(Dose? dose) {
    var displayDose = dose;

    displayDose = displayDose
        ?.convertByWeight(conversionWeight?.toInt())
        .convertByConcentration(conversionConcentration)
        .convertByTime(conversionTime);



    if (maxDose != null &&
        displayDose != null &&
        displayDose.unitEquals(maxDose!)) {
      displayDose = displayDose < maxDose! ? displayDose : maxDose;
    }
    displayDose = displayDose?.scaleAmount(threshold: 0.1);


    return displayDose;
  }
 
// these are the original doses
  Dose? get startDose => originalDose(dosage.dose);
  Dose? get startLowerLimitDose => originalDose(dosage.lowerLimitDose);
  Dose? get startHigherLimitDose => originalDose(dosage.higherLimitDose);
  Dose? get startMaxDose => originalDose(dosage.maxDose);

// these are the converted doses
  Dose? get dose => convertedDose(dosage.dose);
  Dose? get lowerLimitDose => convertedDose(dosage.lowerLimitDose);
  Dose? get higherLimitDose => convertedDose(dosage.higherLimitDose);
  
  // The max dose cant be converted using the same logic as the above, as it leads to stack overflow.
  Dose? get maxDose => dosage.maxDose
      ?.convertByWeight(conversionWeight?.toInt())
      .convertByTime(conversionTime)
      .convertByConcentration(conversionConcentration)
      .scaleAmount(threshold: 0.1);

  /// This returns a string with the conversion information.
  String conversionInfo() {
    final weightConversionInfo = conversionWeight != null
        ? "vikt ${conversionWeight?.weightRound(rounded: true)} kg"
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

    return conversionInfo;
  }
}
