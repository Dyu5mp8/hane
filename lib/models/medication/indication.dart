import 'package:hane/models/medication/bolus_dosage.dart';
import 'package:hane/models/medication/continuous_dosage.dart';

class Indication {
  final String name;
  final List<BolusDosage>? bolus;
  final List<ContinuousDosage>? infusion;
  final String? notes;

  Indication({
    required this.name,
    this.bolus,
    this.infusion,
    this.notes,
  });

  // Convert an Indication instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bolus': bolus?.map((b) => b.toJson()).toList(),
      'infusion': infusion?.map((i) => i.toJson()).toList(),
      'notes': notes,
    };
  }

  // Factory constructor to create an Indication from a Map
  factory Indication.fromFirestore(Map<String, dynamic> map) {
    return Indication(
      name: map['name'] as String,
      bolus: map['bolus'] != null ? (map['bolus'] as List).map((item) => BolusDosage.fromFirestore(item as Map<String, dynamic>)).toList() : null,
      infusion: map['infusion'] != null ? (map['infusion'] as List).map((item) => ContinuousDosage.fromFirestore(item as Map<String, dynamic>)).toList() : null,
      notes: map['notes'] as String?,
    );
  }
}