import 'package:equatable/equatable.dart';
import 'package:hane/drugs/models/composite_unit.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/models/concentration.dart';
import 'package:hane/drugs/models/units.dart';
import 'package:hane/utils/unit_service.dart';
import 'package:hane/utils/smart_rounder.dart';
import 'package:hane/utils/validation_exception.dart';
class Dose<T extends SubstanceUnit<T>> {
  final double amount;
  final T substanceUnit;
  final WeightUnit? weightUnit;
  final TimeUnit? timeUnit;

  Dose({
    required this.amount,
    required this.substanceUnit,
    this.weightUnit,
    this.timeUnit,
  });

  /// copyWith returns a new [Dose] and enforces that the new amount (if provided) is > 0.
  Dose<T> copyWith({
    double? amount,
    T? substanceUnit, // Use T here
    WeightUnit? weightUnit,
    TimeUnit? timeUnit,
  }) {
    double newAmount = amount ?? this.amount;
    if (newAmount <= 0) {
      throw ArgumentError("Dose amount must be greater than 0");
    }
    return Dose<T>(
      amount: newAmount,
      substanceUnit: substanceUnit ?? this.substanceUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      timeUnit: timeUnit ?? this.timeUnit,
    );
  }

  @override
  String toString() {
    return 'Dose{amount: $amount, substanceUnit: $substanceUnit, weightUnit: $weightUnit, timeUnit: $timeUnit}';
  }

  Dose<T> convertByWeight(int weight) {
    if (weightUnit == null) {
      return this;
    }
    double newAmount = amount * weight;
    return Dose<T>(
      amount: newAmount,
      substanceUnit: substanceUnit,
      weightUnit: null,
      timeUnit: timeUnit,
    );
  }

  /// Converts the dose based on a concentration.
  /// Option A: Make this method generic if the unit type is expected to change.
  Dose<U> convertByConcentration<U extends SubstanceUnit<U>>(Concentration concentration) {
    double conversionFactor = substanceUnit.conversionFactor(concentration.substance as T);
    double newAmount = (amount / concentration.amount) * conversionFactor;
    VolumeUnit volumeUnit = concentration.diluent.volumeFromDiluent();

    return Dose<U>(
      amount: newAmount,
      substanceUnit: volumeUnit as U,
      weightUnit: weightUnit,
      timeUnit: timeUnit,
    );
  }

  Dose<T> convertByTime(TimeUnit targetUnit) {
    if (timeUnit == null) {
      return this;
    }
    double factor = targetUnit.factor / timeUnit!.factor;
    double newAmount = amount / factor;
    return Dose<T>(
      amount: newAmount,
      substanceUnit: substanceUnit,
      weightUnit: weightUnit,
      timeUnit: targetUnit,
    );
  }

  Dose<T> scaleAmount(double threshold) {
    // Now using T? for the candidate.
    T? newUnitCandidate = substanceUnit.findCandidateByIdealFactor(amount, threshold);
    if (newUnitCandidate == null) {
      return this;
    }
    final newAmount = amount * substanceUnit.conversionFactor(newUnitCandidate);
    return Dose<T>(
      amount: newAmount,
      substanceUnit: newUnitCandidate,
      weightUnit: weightUnit,
      timeUnit: timeUnit,
    );
  }

    // Factory constructor to create a Dose from a Map
  factory Dose.fromFirestore(Map<String, dynamic> map) {
    num amount = map['amount'] as num;
    String unit = map['unit'] as String;
    
    return Dose.fromString(
      amount: amount.toDouble(),
      unit: map['unit'] as String,
    );
  }

  // Convert a Dose instance to a Map
  Map<String, dynamic> toJson() {
    return {'amount': amount, 'unit': units.values.join('/')};
  }


}