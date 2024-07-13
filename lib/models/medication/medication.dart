import 'package:flutter/material.dart';
import 'package:hane/models/medication/indication.dart';
class Medication extends ChangeNotifier {
  String? _name;
  String? _category;
  List<String>? _concentration;
  String? _contraindication;
  List<Indication>? _adultIndications;
  List<Indication>? _pedIndications;
  String? _notes;

  Medication({
    String? name,
    String? category,
    List<String>? concentration,
    String? contraindication,
    List<Indication>? adultIndications,
    List<Indication>? pedIndications,
    String? notes,
  })  : _name = name,
        _category = category,
        _concentration = concentration,
        _contraindication = contraindication,
        _adultIndications = adultIndications,
        _pedIndications = pedIndications,
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

  List<String>? get concentration => _concentration; 
  set concentration(List<String>? newConcentration) {
    if (_concentration != newConcentration) {
      _concentration = newConcentration;
      notifyListeners();
    }
  }

  String? get contraindication => _contraindication;
  set contraindication(String? newContraindication) {
    if (_contraindication != newContraindication) {
      _contraindication = newContraindication;
      notifyListeners();
    }
  } 

  List<Indication>? get adultIndications => _adultIndications; 
  set adultIndications(List<Indication>? newAdultIndications) {
    if (_adultIndications != newAdultIndications) {
      _adultIndications = newAdultIndications;
      notifyListeners();
    }
  }   

  List<Indication>? get pedIndications => _pedIndications;    
  set pedIndications(List<Indication>? newPedIndications) {
    if (_pedIndications != newPedIndications) {
      _pedIndications = newPedIndications;
      notifyListeners();
    }
  }
  
void addIndication(Indication indication) {
    if (_adultIndications == null) {
      _adultIndications = [];
    }
    _adultIndications!.add(indication);
    notifyListeners();
  }

  // Convert a Medication instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'category': _category,
      'concentration': _concentration,
      'contraindication': _contraindication,
      'adultIndications': _adultIndications?.map((ind) => ind.toJson()).toList(),
      'pedIndications': _pedIndications?.map((ind) => ind.toJson()).toList(),
      'notes': _notes,
    };
  } 

  // Factory constructor to create a Medication from a Map
  factory Medication.fromFirestore(Map<String, dynamic> map) {
    return Medication(
      name: map['name'] as String?,
      category: map['category'] as String?,
      concentration: map['concentration'] != null ? List<String>.from(map['concentration']) : null,
      contraindication: map['contraindication'] as String?,
      adultIndications: (map['adultIndications'] as List?)?.map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList(),
      pedIndications: (map['pedIndications'] as List?)?.map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList(),
      notes: map['notes'] as String?,
    );
  }
}