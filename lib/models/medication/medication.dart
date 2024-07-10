import 'package:hane/models/medication/indication.dart';

class Medication {
  final String? name;
  final String? category;
  final List<String>? concentration;
  final String? contraindication;
  final List<Indication>? adultIndications;
  final List<Indication>? pedIndications;
  final String? notes;

  Medication({
    required this.name,
    this.category,
    this.concentration,
    this.contraindication,
    this.adultIndications,
    this.pedIndications,
    this.notes,
  });

  // Convert a Medication instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'concentration': concentration,
      'contraindication': contraindication,
      'adultIndications': adultIndications?.map((ind) => ind.toJson()).toList(),
      'pedIndications': pedIndications?.map((ind) => ind.toJson()).toList(),
      'notes': notes,
    };
  } 

  // Factory constructor to create a Medication from a Map
  factory Medication.fromFirestore(Map<String, dynamic> map) {
    return Medication(
      name: map['name'] as String?,
      category: map['category'] as String?,
      concentration: map['concentration'] != null ? List<String>.from(map['concentration']) : null,
      contraindication: map['contraindication'] as String?,
      adultIndications: map['adultIndications'] != null ? (map['adultIndications'] as List).map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList() : null,
      pedIndications: map['pedIndications'] != null ? (map['pedIndications'] as List).map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList() : null,
      notes: map['notes'] as String?,
    );
  }
}