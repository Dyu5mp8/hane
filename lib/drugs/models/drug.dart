import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/concentration.dart';
import 'package:hane/drugs/models/indication.dart';

export 'package:hane/drugs/models/dosage.dart';
export 'package:hane/drugs/models/indication.dart';
export 'package:hane/drugs/models/concentration.dart';
export 'package:hane/drugs/models/dose.dart';

class Drug extends ChangeNotifier with EquatableMixin{
  String? _name;
  List<dynamic>? _brandNames;
  String? _genericName;
  List<dynamic>? _categories;
  List<Concentration>? _concentrations;
  String? _contraindication;
  List<Indication>? _indications;
  bool? _changedByUser = false;
  Timestamp? _lastUpdated;
  String? _id;
  String? _userNotes;
  String? _notes;
  String? _reviewedBy;
  bool hasUnreadMessages = false;
  int unreadMessageCount = 0;
  Timestamp? _lastMessageTimestamp;

  Drug({
    String? id,
    String? name,
    bool? changedByUser,
    String? reviewedBy,
    List<dynamic>? brandNames,
    String? genericName,
    List<dynamic>? categories,
    List<Concentration>? concentrations = const [],
    String? contraindication = '',
    List<Indication>? indications,
    String? notes = '',
    String? userNotes,
    Timestamp? lastUpdated,
    Timestamp? lastMessageTimestamp

  })  : _name = name ?? '',
        _changedByUser = changedByUser,
        _reviewedBy = reviewedBy,
        _lastUpdated = lastUpdated,
        _categories = categories,
        _concentrations = concentrations,
        _contraindication = contraindication,
        _indications = indications,
        _notes = notes,
        _brandNames = brandNames,
        _genericName = genericName,
        _id = id,
        _userNotes = userNotes,
        _lastMessageTimestamp = lastMessageTimestamp;


  Drug.from(Drug drug)
      : 
        _id = drug.id,
        _name = drug.name,
        _genericName = drug._genericName,
        _reviewedBy = drug._reviewedBy,
        _changedByUser = drug.changedByUser,
        _lastUpdated = drug.lastUpdated,
        _categories = drug.categories,
        _concentrations = drug.concentrations,
        _contraindication = drug.contraindication,
        _indications = drug._indications != null
            ? List<Indication>.from(drug._indications!.map((ind) => Indication.from(ind)))
            : null,
        _notes = drug.notes,
        _userNotes = drug.userNotes,
        _brandNames = drug.brandNames,
        _lastMessageTimestamp = drug._lastMessageTimestamp,
        hasUnreadMessages = drug.hasUnreadMessages;


  @override
  List<Object?> get props => [
        _id,
        _name,
        _genericName,
        _reviewedBy,
        _changedByUser,
        _lastUpdated,
        _categories,
        _concentrations,
        _contraindication,
        _indications,
        _notes,
        _brandNames
      ];

  String? get id => _id;
  set id(String? newId) {
    if (_id != newId) {
      _id = newId;
      notifyListeners();
    }
  }

  String? get name => _name;
  set name(String? newName) {
    if (_name != newName) {
      _name = newName;
      notifyListeners();
    }
  }

  String preferredDisplayName({bool preferGeneric = false}) {

    if (preferGeneric) {
      return _genericName ?? _name!;
    } else {
      return _name!;
    }
  }
List<dynamic>? preferredSecondaryNames({bool preferGeneric = false}) {
  if (preferGeneric) {
    // Initialize a Set with _brandNames or an empty Set if null
    Set<dynamic> tempNames = _brandNames?.toSet() ?? {};

    // Add _name to the set if it's not null
    if (_name != null) {
      tempNames.add(_name!);
    }

    // Determine the name to remove
    String? nameToRemove = _genericName ?? _name;

    // Remove the name to exclude from the set
    if (nameToRemove != null) {
      tempNames.remove(nameToRemove);
    }

    // Return the list if it's not empty, else return null
    return tempNames.isNotEmpty ? tempNames.toList() : null;
  } else {
    // When preferGeneric is false, return the brand names as they are
    return _brandNames;
  }
}
  String? get userNotes => _userNotes;
  set userNotes(String? newUserNotes) {
    if (_userNotes != newUserNotes) {
      _userNotes = newUserNotes;
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

  String? get reviewedBy => _reviewedBy;
  set reviewedBy(String? newReviewedBy) {
    if (_reviewedBy != newReviewedBy) {
      _reviewedBy = newReviewedBy;
      notifyListeners();
    }
  }

  markMessagesAsRead() {
    hasUnreadMessages = false;
    notifyListeners();

  }

  Timestamp? get lastUpdated => _lastUpdated;
  set lastUpdated(Timestamp? newLastUpdated) {
    if (_lastUpdated != newLastUpdated) {
      _lastUpdated = newLastUpdated;
      notifyListeners();
    }
  }

  List<dynamic>? getOnlyBrandNames() {
    var tempNames = _brandNames?.toList();
    tempNames?.removeWhere((element) => element == _genericName);
    return tempNames;
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

  String? get genericName => _genericName;
  set genericName(String? newGenericName) {
    if (_genericName != newGenericName) {
      _genericName = newGenericName;
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
    return _concentrations
        ?.map((conc) => conc.toString())
        .toList();
  
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
      'id': _id,
      'name': _name,
      'genericName': _genericName,
      'changedByUser': _changedByUser,
      'reviewedBy': _reviewedBy,
      'brandNames': _brandNames,
      'categories': _categories,
      'concentrations': concentrations?.map((c) => c.toJson()).toList(),
      'contraindication': _contraindication,
      'indications': indications?.map((ind) => ind.toJson()).toList(),
      'notes': _notes,
      'lastUpdated': _lastUpdated,
      'lastMessageTimestamp': _lastMessageTimestamp,

    };
  }

  factory Drug.fromFirestore(Map<String, dynamic> map) {
  // Debugging print to log the document being parsed


  return Drug(
    id: map['id'] as String?,
    name: map['name'] as String?,
    genericName: map.containsKey('genericName') ? map['genericName'] as String? : null,
    changedByUser: map['changedByUser'] as bool?,
    reviewedBy: map['reviewedBy'] as String?,
    categories: (map['categories'] as List<dynamic>?),
    concentrations: (map['concentrations'] as List<dynamic>?)
        ?.map((item) => Concentration.fromMap(item as Map<String, dynamic>))
        .toList(),
    brandNames: (map['brandNames'] as List<dynamic>?),
    contraindication: map['contraindication'] as String?,
    indications: (map['indications'] as List?)
        ?.map((item) => Indication.fromFirestore(item as Map<String, dynamic>))
        .toList(),
    notes: map['notes'] as String?,
    lastUpdated: map['lastUpdated'] as Timestamp?,
    lastMessageTimestamp: map['lastMessageTimestamp'],
  );

  }
}
