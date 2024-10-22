import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/concentration.dart';
import 'package:hane/drugs/models/indication.dart';

export 'package:hane/drugs/models/dosage.dart';
export 'package:hane/drugs/models/indication.dart';
export 'package:hane/drugs/models/concentration.dart';
export 'package:hane/drugs/models/dose.dart';

class Drug extends ChangeNotifier with EquatableMixin {
  String? _name;
  List<dynamic>? _brandNames;
  String? _genericName;
  List<dynamic>? _categories;
  List<Concentration>? _concentrations;
  String? _contraindication;
  String? _expandedContraindication;
  List<Indication>? _indications;
  bool? _changedByUser = false;
  Timestamp? _lastUpdated;
  String? _id;
  String? _userNotes;
  String? _notes;
  String? _expandedNotes;
  String? _reviewedBy;
  bool hasUnreadMessages = false;
  int unreadMessageCount = 0;
  Timestamp? _lastMessageTimestamp;

  Drug(
      {String? id,
      String? name,
      bool? changedByUser,
      String? reviewedBy,
      List<dynamic>? brandNames,
      String? genericName,
      List<dynamic>? categories,
      List<Concentration>? concentrations = const [],
      String? contraindication = '',
      String? expandedContraindication = '',
      List<Indication>? indications,
      String? notes = '',
      String? expandedNotes = '',
      String? userNotes,
      Timestamp? lastUpdated,
      Timestamp? lastMessageTimestamp})
      : _name = name ?? '',
        _changedByUser = changedByUser,
        _reviewedBy = reviewedBy,
        _lastUpdated = lastUpdated,
        _categories = categories,
        _concentrations = concentrations,
        _contraindication = contraindication,
        _expandedContraindication = expandedContraindication,
        _indications = indications,
        _notes = notes,
        _expandedNotes = expandedNotes,
        _brandNames = brandNames,
        _genericName = genericName,
        _id = id,
        _userNotes = userNotes,
        _lastMessageTimestamp = lastMessageTimestamp;

  Drug.from(Drug drug)
      : _id = drug.id,
        _name = drug.name,
        _genericName = drug._genericName,
        _reviewedBy = drug._reviewedBy,
        _changedByUser = drug.changedByUser,
        _lastUpdated = drug.lastUpdated,
        _categories = drug.categories,
        _concentrations = drug.concentrations,
        _contraindication = drug.contraindication,
        _expandedContraindication = drug._expandedContraindication,
        _indications = drug._indications != null
            ? List<Indication>.from(
                drug._indications!.map((ind) => Indication.from(ind)))
            : null,
        _notes = drug.notes,
        _expandedNotes = drug._expandedNotes,
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
        _expandedContraindication,
        _indications,
        _notes,
        _expandedNotes,
        _brandNames
      ];

  void updateDrug() {
    notifyListeners();
  }

  markMessagesAsRead() {
    hasUnreadMessages = false;
    notifyListeners();
  }

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

  String? get expandedNotes => _expandedNotes;
  set expandedNotes(String? newExpandedNotes) {
    if (_expandedNotes != newExpandedNotes) {
      _expandedNotes = newExpandedNotes;
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
    return _concentrations?.map((conc) => conc.toString()).toList();
  }

  String? get contraindication => _contraindication;
  set contraindication(String? newContraindication) {
    if (_contraindication != newContraindication) {
      _contraindication = newContraindication;
      notifyListeners();
    }
  }

  String? get expandedContraindication => _expandedContraindication;
  set expandedContraindication(String? newExpandedContraindication) {
    if (_expandedContraindication != newExpandedContraindication) {
      _expandedContraindication = newExpandedContraindication;
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
      'expandedContraindication': _expandedContraindication,
      'indications': indications?.map((ind) => ind.toJson()).toList(),
      'notes': _notes,
      'expandedNotes': _expandedNotes,
      'lastUpdated': _lastUpdated,
      'lastMessageTimestamp': _lastMessageTimestamp,
    };
  }

  factory Drug.fromFirestore(Map<String, dynamic> map) {
    // Debugging print to log the document being parsed

    return Drug(
      id: map['id'] as String?,
      name: map['name'] as String?,
      genericName:
          map.containsKey('genericName') ? map['genericName'] as String? : null,
      changedByUser: map['changedByUser'] as bool?,
      reviewedBy: map['reviewedBy'] as String?,
      categories: (map['categories'] as List<dynamic>?),
      concentrations: (map['concentrations'] as List<dynamic>?)
          ?.map((item) => Concentration.fromMap(item as Map<String, dynamic>))
          .toList(),
      brandNames: (map['brandNames'] as List<dynamic>?),
      contraindication: map['contraindication'] as String?,
      expandedContraindication: map['expandedContraindication'] as String?,
      indications: (map['indications'] as List?)
          ?.map(
              (item) => Indication.fromFirestore(item as Map<String, dynamic>))
          .toList(),
      notes: map['notes'] as String?,
      expandedNotes: map['expandedNotes'] as String?,
      lastUpdated: map['lastUpdated'] as Timestamp?,
      lastMessageTimestamp: map['lastMessageTimestamp'],
    );
  }
}
