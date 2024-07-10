import 'package:hane/models/medication/dose.dart';

class BolusDosage {
  final String? instruction;
  final String? administrationRoute;
  final Map<String, Dose>? dose;
  final Map<String, Dose>? weightBasedDose;

  BolusDosage({
    this.instruction,
    this.administrationRoute,
    this.dose,
    this.weightBasedDose,
  });

  // Convert a BolusDosage instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'instruction': instruction,
      'administration_route': administrationRoute,
      'dose': dose?.map((key, value) => MapEntry(key, value.toJson())),
      'weight_based_dose': weightBasedDose?.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  // Factory constructor to create a BolusDosage from a Map
  factory BolusDosage.fromFirestore(Map<String, dynamic> map) {
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

    return BolusDosage(
      instruction: map['instruction'] as String?,
      administrationRoute: map['administration_route'] as String?,
      dose: doseMap,
      weightBasedDose: weightBasedDoseMap,
    );
  }
}