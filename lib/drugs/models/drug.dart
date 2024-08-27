
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/concentration.dart';
import 'package:hane/drugs/models/indication.dart';


export 'package:hane/drugs/models/dosage.dart';
export 'package:hane/drugs/models/indication.dart';
export 'package:hane/drugs/models/concentration.dart';
export 'package:hane/drugs/models/dose.dart';


class Drug extends ChangeNotifier {
  String? _name;
  List<dynamic>? _brandNames;
  List<dynamic>? _categories;
  List<Concentration>? _concentrations;
  String? _contraindication;
  List<Indication>? _indications;
  bool? _changedByUser = false;
  Timestamp? _lastUpdated;

  String? _notes;

  Drug({
    String? name,
    bool? changedByUser,
    List<dynamic>? brandNames,
    List<dynamic>? categories,
   List<Concentration>? concentrations,
    String? contraindication,
    List<Indication>? indications,
    String? notes,
    Timestamp? lastUpdated,
  })  : _name = name,
        _changedByUser = changedByUser,
        _lastUpdated = lastUpdated,
        _categories = categories,
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

  bool get changedByUser => _changedByUser ?? false;
  set changedByUser(bool newChangedByUser) {
    if (_changedByUser != newChangedByUser) {
      _changedByUser = newChangedByUser;
      notifyListeners();
    }
  }

  Timestamp? get lastUpdated => _lastUpdated;
  set lastUpdated(Timestamp? newLastUpdated) {
    if (_lastUpdated != newLastUpdated) {
      _lastUpdated = newLastUpdated;
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

  List<dynamic>? get categories => _categories;
  set categories(List<dynamic>? newcategories) {
    if (_categories != newcategories) {
      _categories = newcategories;
      notifyListeners();
    }
  }



  List<Concentration>? get concentrations => _concentrations;

  set concentrations(List<Concentration>? newConcentrations) {
    if (_concentrations != newConcentrations) {
      _concentrations = newConcentrations;
      
      notifyListeners();
    }
  }

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

  void updateDrug() {
    notifyListeners();
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

  // Convert a Drug instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'changedByUser': _changedByUser,
      'brandNames': _brandNames,
      'categories': _categories,
      'concentrations': concentrations?.map((c) => c.toJson()).toList(),
      'contraindication': _contraindication,
      'indications': indications?.map((ind) => ind.toJson()).toList(),
      'notes': _notes,
      'lastUpdated': _lastUpdated
    };
  } 


  // Factory constructor to create a Drug from a Map
  factory Drug.fromFirestore(Map<String, dynamic> map) {
    return Drug(
      name: map['name'] as String?,
      changedByUser: map['changedByUser'] as bool?,
      categories: (map['categories'] as List<dynamic>?),
      concentrations: (map['concentrations'] as List<dynamic>?)?.map((item) => Concentration.fromMap(item as Map<String, dynamic>))
        .toList(),
      brandNames:(map['brandNames'] as List<dynamic>?),
      contraindication: map['contraindication'] as String?,
      indications: (map['indications'] as List?)?.map((item) => Indication.fromFirestore(item as Map<String, dynamic>)).toList(),
      notes: map['notes'] as String?,
      lastUpdated: map['lastUpdated'] as Timestamp?,
    );
  }



}