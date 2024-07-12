import 'package:flutter/material.dart';
import 'package:hane/models/medication/indication.dart';

class Medication extends ChangeNotifier {
  String? name;
  final String? category;
  final List<String>? concentration;
  final String? contraindication;
  final List<Indication>? adultIndications;
  final List<Indication>? pedIndications;
  String? notes;

  Medication({
    required this.name,
    this.category,
    this.concentration,
    this.contraindication,
    this.adultIndications,
    this.pedIndications,
    this.notes,
  });

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  set notes(String notes) {
    this.notes = notes;
    notifyListeners();
  }

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