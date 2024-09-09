import 'package:hane/drugs/models/dose.dart';

class Dosage {
  final String? instruction;
  final String? administrationRoute;
  final Dose? dose;
  final Dose? lowerLimitDose;
  final Dose? higherLimitDose;
  final Dose? maxDose;

  Dosage({
    this.instruction,
    this.administrationRoute,
    this.dose,
    this.lowerLimitDose,
    this.higherLimitDose,
    this.maxDose,
  });

  // Convert a BolusDosage instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'instruction': instruction,
      'administration_route': administrationRoute,
      'dose': dose?.toJson(),
      'lower_limit_dose': lowerLimitDose?.toJson(),
      'higher_limit_dose': higherLimitDose?.toJson(),
      'max_dose': maxDose?.toJson(),
    };
  }

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
