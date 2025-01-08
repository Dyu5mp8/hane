import 'package:cloud_firestore/cloud_firestore.dart';

class Antibiotic {
  final String? category;
  final String? name;
  final String? description;        // maps from "Deklaration"
  final String? pharmacodynamics;
  final String? pharmacokinetics;
  final String? activity;   // maps from "Farmakodynamik"
  final String? dosage;             // maps from "Dosering"
  final String? sideEffects;        // maps from "Biverkningar"
  final String? interactions;
  final String? assessment;
  final String? resistance;

  Antibiotic({
    this.category,
    this.name,
    this.description,
    this.pharmacodynamics,
    this.pharmacokinetics,
    this.activity,
    this.dosage,
    this.sideEffects,
    this.interactions,
    this.assessment,
    this.resistance,
  });

  /// Creates an Antibiotic from a Firestore/JSON map.
  factory Antibiotic.fromMap(Map<String, dynamic> map) {
    return Antibiotic(
      category: map['category'] as String?,
      name: map['antibioticName'] as String?,  
      description: map['Deklaration'] as String?,       
      pharmacodynamics: map['Farmakodynamik'] as String?,
      pharmacokinetics: map['Farmakokinetik'] as String?,
      activity: map['Brytpunkter och mikrobiologisk aktivitet'] as String?,
      dosage: map['Dosering'] as String?,
      sideEffects: map['Biverkningar'] as String?,
      interactions: map['Interaktioner'] as String?,
      assessment: map['RAFs bedömning'] as String?,
      resistance: map['Resistensutveckling'] as String?,
    );
  }

  /// Creates an Antibiotic from a DocumentSnapshot.
  factory Antibiotic.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return Antibiotic();
    }
    return Antibiotic.fromMap(data);
  }

  /// Fetch antibiotics from Firestore, checking the cache first, then server.
/// Fetch antibiotics from Firestore, checking the cache first, then server.
static Future<List<Antibiotic>> fetchFromCacheFirstThenServer() async {
  final collectionRef = FirebaseFirestore.instance.collection('antibiotics');
  QuerySnapshot querySnapshot;

  try {
    querySnapshot =
        await collectionRef.get(const GetOptions(source: Source.server));
  } catch (e) {
    querySnapshot = await collectionRef.get();
  }

  // Map documents to Antibiotic objects and sort them alphabetically by name
  final antibiotics = querySnapshot.docs
      .map((doc) => Antibiotic.fromDocument(doc))
      .toList();

  antibiotics.sort((a, b) {
    final nameA = (a.name ?? '').toLowerCase();
    final nameB = (b.name ?? '').toLowerCase();
    return nameA.compareTo(nameB);
  });

  return antibiotics;
}
}