import 'package:flutter/material.dart';
import 'package:hane/drugs/models/dose.dart';
class Dosage  {
  String? _instruction;
  String? _administrationRoute;
  Dose? _dose;
  Dose? _lowerLimitDose;
  Dose? _higherLimitDose;
  Dose? _maxDose;

  Dosage({
    String? instruction,
    String? administrationRoute,
    Dose? dose,
    Dose? lowerLimitDose,
    Dose? higherLimitDose,
    Dose? maxDose,
  })  : _instruction = instruction,
        _administrationRoute = administrationRoute,
        _dose = dose,
        _lowerLimitDose = lowerLimitDose,
        _higherLimitDose = higherLimitDose,
        _maxDose = maxDose;

  // Getters
  String? get instruction => _instruction;
  String? get administrationRoute => _administrationRoute;
  Dose? get dose => _dose;
  Dose? get lowerLimitDose => _lowerLimitDose;
  Dose? get higherLimitDose => _higherLimitDose;
  Dose? get maxDose => _maxDose;

  // Setters with notification
  set instruction(String? newInstruction) {
    _instruction = newInstruction;
    
  }

  set administrationRoute(String? newRoute) {
    _administrationRoute = newRoute;
    
  }

  set dose(Dose? newDose) {
    _dose = newDose;
    
  }

  set lowerLimitDose(Dose? newLowerLimitDose) {
    _lowerLimitDose = newLowerLimitDose;
    
  }

  set higherLimitDose(Dose? newHigherLimitDose) {
    _higherLimitDose = newHigherLimitDose;
    
  }

  set maxDose(Dose? newMaxDose) {
    _maxDose = newMaxDose;
    
  }

  void updateDosage(Dosage updatedDosage) {
    _instruction = updatedDosage.instruction;
    _administrationRoute = updatedDosage.administrationRoute;
    _dose = updatedDosage.dose;
    _lowerLimitDose = updatedDosage.lowerLimitDose;
    _higherLimitDose = updatedDosage.higherLimitDose;
    _maxDose = updatedDosage.maxDose;
    
  }

  // Convert Dosage to JSON
  Map<String, dynamic> toJson() {
    return {
      'instruction': _instruction,
      'administration_route': _administrationRoute,
      'dose': _dose?.toJson(),
      'lower_limit_dose': _lowerLimitDose?.toJson(),
      'higher_limit_dose': _higherLimitDose?.toJson(),
      'max_dose': _maxDose?.toJson(),
    };
  }

  // Factory to create Dosage from Firestore
  factory Dosage.fromFirestore(Map<String, dynamic> map) {
    return Dosage(
      instruction: map['instruction'] as String?,
      administrationRoute: map['administration_route'] as String?,
      dose: map['dose'] != null
          ? Dose.fromFirestore(map['dose'] as Map<String, dynamic>)
          : null,
      lowerLimitDose: map['lower_limit_dose'] != null
          ? Dose.fromFirestore(map['lower_limit_dose'] as Map<String, dynamic>)
          : null,
      higherLimitDose: map['higher_limit_dose'] != null
          ? Dose.fromFirestore(map['higher_limit_dose'] as Map<String, dynamic>)
          : null,
      maxDose: map['max_dose'] != null
          ? Dose.fromFirestore(map['max_dose'] as Map<String, dynamic>)
          : null,
    );
  }
}