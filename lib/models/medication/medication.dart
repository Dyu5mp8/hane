
import 'package:flutter/material.dart';
import 'package:hane/models/medication/concentration.dart';
import 'package:hane/models/medication/indication.dart';
class Medication extends ChangeNotifier {
  String? _name;
  String? _category;
  List<({double amount, String unit})>? _concentrations;
  String? _contraindication;
  List<Indication>? _indications;

  String? _notes;

  Medication({
    String? name,
    String? category,
   List<({double amount, String unit})>? concentrations,
    String? contraindication,
    List<Indication>? indications,
    String? notes,
  })  : _name = name,
        _category = category,
        _concentrations = concentrations,
        _contraindication = contraindication,
        _indications = indications,
        _notes = notes;

  String? get name => _name;
  set name(String? newName) {
    if (_name != newName) {
      _name = newName;
      notifyListeners();
    }
  }

  String? get notes => _notes;
  set notes(String? newNotes) {
    if (_notes != newNotes) {
      _notes = newNotes;
      notifyListeners();
    }
  }

  String? get category => _category;
  set category(String? newCategory) {
    if (_category != newCategory) {
      _category = newCategory;
      notifyListeners();
    }
  }

  List<({double amount, String unit})>? get concentrations => _concentrations;

  List<String>? getConcentrationsAsString() {

    return _concentrations?.map((conc) => "${conc.amount} ${conc.unit}").toList();
  }

  String? get contraindication => _contraindication;
  set contraindication(String? newContraindication) {
    if (_contraindication != newContraindication) {
      _contraindication = newContraindication;
      notifyListeners();
    }
  } 

  List<Indication>? get indications => _indications ?? [];
  set indications(List<Indication>? newIndications) {
    if (_indications != newIndications) {
      _indications = newIndications;
      notifyListeners();
    }
  }
  
  List<Indication>? get adultIndications {
    var adult = _indications?.where((ind) => !ind.isPediatric).toList();
    return adult ?? [];
  }

  List<Indication>? get pedIndications {
      var ped = _indications?.where((ind) => ind.isPediatric).toList();
      return ped ?? [];
    }

void addIndication(Indication indication) {
    this.indications = this.indications ?? [];
    indications!.add(indication);
    notifyListeners();
  }

  // Convert a Medication instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'category': _category,
      'concentrations': _concentrations,
      'contraindication': _contraindication,
      'indications': indications?.map((ind) => ind.toJson()).toList(),
      'notes': _notes,
    };
  } 

  // Factory constructor to create a Medication from a Map
  factory Medication.fromFirestore(Map<String, dynamic> map) {
    return Medication(
      name: map['name'] as String?,
      category: map['category'] as String?,
      concentrations: map['concentrations'] as List<({double amount, String unit})>?,
      contraindication: map['contraindication'] as String?,
      indications: (map['indications'] as List?)?.map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList(),
      notes: map['notes'] as String?,
    );
  }
}