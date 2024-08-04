import 'package:hane/medications/models/dose.dart';

class ContinuousDosage {
  final String? instruction;
  final String? administrationRoute;
  final Map<String, Dose>? dose;
  final Map<String, Dose>? weightBasedDose;
  final String? timeUnit;

  ContinuousDosage({
    this.instruction,
    this.administrationRoute,
    this.dose,
    this.weightBasedDose,
    this.timeUnit,
  });

  // Convert a ContinuousDosage instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'instruction': instruction,
      'administration_route': administrationRoute,
      'dose': dose?.map((key, value) => MapEntry(key, value.toJson())),
      'weight_based_dose': weightBasedDose?.map((key, value) => MapEntry(key, value.toJson())),
      'time_unit': timeUnit,
    };
  }

  // Factory constructor to create a ContinuousDosage from a Map
  factory ContinuousDosage.fromFirestore(Map<String, dynamic> map) {
    Map<String, Dose> doseMap = {};
    Map<String, Dose> weightBasedDoseMap = {};

    if (map['dose'] != null) {
      doseMap = (map['dose'] as Map<String, dynamic>).map((key, value) =>
        MapEntry(key, Dose.fromFirestore(value as Map<String, dynamic>)));
    }
    if (map['weight_based_dose'] != null) {
      weightBasedDoseMap = (map['weight_based_dose'] as Map<String, dynamic>).map((key, value) =>
        MapEntry(key, Dose.fromFirestore(value as Map<String, dynamic>)));
    }

    return ContinuousDosage(
      instruction: map['instruction'] as String?,
      administrationRoute: map['administration_route'] as String?,
      dose: doseMap,
      weightBasedDose: weightBasedDoseMap,
      timeUnit: map['time_unit'] as String?,
    );
  }
}