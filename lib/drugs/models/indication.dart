import 'package:hane/drugs/models/dosage.dart';


class Indication {
  final String name;
  List<Dosage>? dosages;
  final String? notes;
  bool isPediatric;


  Indication({
    required this.name,
    required this.isPediatric,
    this.dosages,
    this.notes,
  });


  // Convert an Indication instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosages': dosages?.map((b) => b.toJson()).toList(),
      'notes': notes,
    };
  }

  // Factory constructor to create an Indication from a Map
  factory Indication.fromFirestore(Map<String, dynamic> map) {
    return Indication(
      name: map['name'] as String,
      dosages: map['dosages'] != null ? (map['dosages'] as List).map((item) => Dosage.fromFirestore(item as Map<String, dynamic>)).toList() : null,
      notes: map['notes'] as String?,
      isPediatric: map['isPediatric'] ?? false,
    );
  }



int get totalDosageInstructions => (dosages?.length ?? 0);

}