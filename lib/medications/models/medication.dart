
import 'package:flutter/material.dart';
import 'package:hane/medications/models/concentration.dart';
import 'package:hane/medications/models/indication.dart';

export 'package:hane/medications/models/concentration.dart';
export 'package:hane/medications/models/dose.dart';

class Medication extends ChangeNotifier {
  String? _name;
  List<dynamic>? _brandNames;
  String? _category;
  List<Concentration>? _concentrations;
  String? _contraindication;
  List<Indication>? _indications;

  String? _notes;

  Medication({
    String? name,
    List<dynamic>? brandNames,
    String? category,
   List<Concentration>? concentrations,
    String? contraindication,
    List<Indication>? indications,
    String? notes,
  })  : _name = name,
        _category = category,
        _concentrations = concentrations,
        _contraindication = contraindication,
        _indications = indications,
        _notes = notes,
        _brandNames = brandNames;

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

  List<dynamic>? get brandNames => _brandNames;
  set brandNames(List<dynamic>? newBrandNames) {
    if (_brandNames != newBrandNames) {
      _brandNames = newBrandNames;
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

  List<Concentration>? get concentrations => _concentrations;

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
      'brandNames': _brandNames,
      'category': _category,
      'concentrations': concentrations?.map((c) => c.toJson()).toList(),
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
      concentrations: (map['concentrations'] as List<dynamic>?)?.map((item) => Concentration.fromMap(item as Map<String, dynamic>))
        .toList(),
      brandNames:(map['brandNames'] as List<dynamic>?),
      contraindication: map['contraindication'] as String?,
      indications: (map['indications'] as List?)?.map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList(),
      notes: map['notes'] as String?,
    );
  }



}