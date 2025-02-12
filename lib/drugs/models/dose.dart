import 'package:equatable/equatable.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/models/units.dart';
import 'package:hane/utils/smart_rounder.dart';

class Dose extends Equatable {
  final double amount;
  final SubstanceUnit substanceUnit;
  final WeightUnit? weightUnit;
  final TimeUnit? timeUnit;

  const Dose({
    required this.amount,
    required this.substanceUnit,
    this.weightUnit,
    this.timeUnit,
  });

  /// Creates a new Dose with the given fields replaced.
  Dose copyWith({
    double? amount,
    SubstanceUnit? substanceUnit,
    WeightUnit? weightUnit,
    TimeUnit? timeUnit,
  }) {
    final newAmount = amount ?? this.amount;
    if (newAmount < 0) {
      throw ArgumentError("Dose amount must be greater than 0");
    }
    return Dose(
      amount: newAmount,
      substanceUnit: substanceUnit ?? this.substanceUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      timeUnit: timeUnit ?? this.timeUnit,
    );
  }

  @override
  String toString() {
    Dose scaledDose = scaleAmount();
    return ("${scaledDose.amount} ${scaledDose.unitString}"); 
  }

   bool operator <(Dose other) {
    // Check that the substance units come from the same implementation.
    if (substanceUnit.unitType != other.substanceUnit.unitType) {
      throw Exception(
          "Cannot compare doses with different substance unit implementations.");
    }

    // If weight units are present, they must be identical.
    if (weightUnit != other.weightUnit) {
      throw Exception(
          "Cannot compare doses with different weight units (or one is null and the other is not).");
    }
    // Both doses must either have a time unit or not.
    if ((timeUnit == null) != (other.timeUnit == null)) {
      throw Exception(
          "Cannot compare doses when one dose has a time unit and the other does not.");
    }
    // Convert this dose’s substance amount to the other’s substance unit.
    // (For example, mg to g: amount_in_g = amount_in_mg * (g.factor / mg.factor)).
    double convertedAmount =
        amount * substanceUnit.conversionFactor(other.substanceUnit);

    // If both doses have a time unit, convert the rate.
    // The conversion is analogous to Dose.convertByTime:
    // newAmount = amount * (this.timeUnit.factor / other.timeUnit.factor)
    if (timeUnit != null && other.timeUnit != null) {
      convertedAmount *= (timeUnit!.factor / other.timeUnit!.factor);
    }
    // Now, other.amount is already expressed in its own substance (and time) unit.
    // We compare the converted amount of this dose with the raw amount of the other.
    return convertedAmount < other.amount;
  }




  /// Define the > operator in terms of <.
  bool operator >(Dose other) => other < this;

  bool unitEquals(Dose other) {
    return substanceUnit.unitType == other.substanceUnit.unitType &&
        weightUnit == other.weightUnit &&
        timeUnit == other.timeUnit;
  }

  

  /// Converts the dose by applying a weight factor.
  Dose convertByWeight(int? weight) {
    if (weight == null || weightUnit == null ) return this;
    final newAmount = amount * weight;
    return Dose(
      amount: newAmount,
      substanceUnit: substanceUnit,
      weightUnit: null,
      timeUnit: timeUnit,
    );
  }

  /// Converts the dose by a concentration.
  Dose convertByConcentration(Concentration? concentration) {
    if (concentration == null) return this; 
    final convFactor = substanceUnit.conversionFactor(concentration.substance);
    final newAmount = (amount / concentration.amount) * convFactor;
    final volumeUnit = concentration.diluent.volumeFromDiluent();
    return Dose(
      amount: newAmount,
      substanceUnit: volumeUnit,
      weightUnit: weightUnit,
      timeUnit: timeUnit,
    );
  }

  /// Converts the dose to a new time unit.
  Dose convertByTime(TimeUnit? targetUnit) {
    if (timeUnit == null || targetUnit == null) return this;
    final factor = targetUnit.factor / timeUnit!.factor;
    final newAmount = amount / factor;
    return Dose(
      amount: newAmount,
      substanceUnit: substanceUnit,
      weightUnit: weightUnit,
      timeUnit: targetUnit,
    );
  }

  /// Scales the dose by trying to find a candidate unit such that
  /// `amount * conversionFactor(candidate)` comes close to [threshold].
  Dose scaleAmount({double threshold = 0.5}) {
    final newUnitCandidate = substanceUnit.findCandidateByIdealFactor(amount, threshold);
    if (newUnitCandidate == null) return this;
    final newAmount = amount * substanceUnit.conversionFactor(newUnitCandidate);
    return Dose(
      amount: newAmount,
      substanceUnit: newUnitCandidate,
      weightUnit: weightUnit,
      timeUnit: timeUnit,
    );
  }

  Dose roundAmount() {
    final newAmount = smartRound(amount) as double  ;
    return copyWith(amount: newAmount);
  }

  /// Returns a string representation of the dose units.
  String get unitString {
    var unitStr = substanceUnit.toString();
    if (weightUnit != null) unitStr += '/${weightUnit.toString()}';
    if (timeUnit != null) unitStr += '/${timeUnit.toString()}';
    return unitStr;
  }

  /// Creates a Dose from a dose string.
  ///
  /// The string can have one to three parts separated by '/'.
  /// 1. One part: Only substance unit.
  /// 2. Two parts: Either substance and weight OR substance and time.
  /// 3. Three parts: Substance, weight, and time.
  ///
  /// Throws an [ArgumentError] if the string is invalid.
  factory Dose.fromString(double amount, String doseStr) {
    final parts = doseStr.split('/').map((s) => s.trim()).toList();
    if (parts.isEmpty || parts.length > 3) {
      throw ArgumentError("Invalid dose string: $doseStr");
    }

    try {
      final SubstanceUnit substance = SubstanceUnit.fromString(parts[0]);
      WeightUnit? weight;
      TimeUnit? time;

      if (parts.length == 1) {
        // Only substance provided.
        return Dose(
          amount: amount,
          substanceUnit: substance,
        );
      } else if (parts.length == 2) {
        // Try parsing second part as WeightUnit first.
        try {
          weight = WeightUnit.fromString(parts[1]);
          return Dose(
            amount: amount,
            substanceUnit: substance,
            weightUnit: weight,
          );
        } catch (e) {
          // If that fails, try parsing as TimeUnit.
          try {
            time = TimeUnit.fromString(parts[1]);
            return Dose(
              amount: amount,
              substanceUnit: substance,
              timeUnit: time,
            );
          } catch (e2) {
            throw ArgumentError(
                "Invalid dose string: $doseStr. Cannot parse '${parts[1]}' as WeightUnit or TimeUnit.");
          }
        }
      } else if (parts.length == 3) {
        // Expect second part as WeightUnit and third as TimeUnit.
        weight = WeightUnit.fromString(parts[1]);
        time = TimeUnit.fromString(parts[2]);
        return Dose(
          amount: amount,
          substanceUnit: substance,
          weightUnit: weight,
          timeUnit: time,
        );
      }
      throw ArgumentError("Invalid dose string: $doseStr");
    } catch (e) {
      throw ArgumentError("Invalid dose string: $doseStr. Error: $e");
    }
  }

  /// Creates a Dose from a Firestore map.
  factory Dose.fromFirestore(Map<String, dynamic> map) {
    final num amt = map['amount'] as num;
    final String unitStr = map['unit'] as String;
    return Dose.fromString(amt.toDouble(), unitStr);
  }

  /// Converts the Dose to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unitString,
    };
  }

  @override
  List<Object?> get props => [amount, substanceUnit, weightUnit, timeUnit];
}