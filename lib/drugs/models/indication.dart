import 'package:hane/drugs/models/dosage.dart';


class Indication {
  // Private fields
  String _name;
  List<Dosage>? dosages;
  String? _notes;
  bool isPediatric;

  Indication({
    required String name,
    required this.isPediatric,
    this.dosages,
    String? notes,
  })  : _name = name,
        _notes = notes;

  Indication.from(Indication indication)
      : _name = indication.name,
        dosages = indication.dosages?.map((dosage) => Dosage.from(dosage)).toList(),
        _notes = indication.notes,
        isPediatric = indication.isPediatric;

  // Getter for name
  String get name => _name;

  // Setter for name
  set name(String newName) {
    if (_name != newName) {
      _name = newName;
    }
  }

  // Getter for notes
  String? get notes => _notes;

  // Setter for notes
  set notes(String? newNotes) {
    if (_notes != newNotes) {
      _notes = newNotes;
    }
  }


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