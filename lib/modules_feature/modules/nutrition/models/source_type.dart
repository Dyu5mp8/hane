enum SourceType {
  parenteral,
  medication,
  enteral,
  oral,
  glucose;

  factory SourceType.fromJson(Map<String, dynamic> json) {
    // Assuming the JSON contains a key 'type' whose value is the string representation of the enum.
    final String typeString = json['type'] as String;

    return SourceType.values.firstWhere(
      (e) => (e.name) == typeString,
      orElse: () => throw ArgumentError('Invalid SourceType: $typeString'),
    );
  }

  String get displayName {
    switch (this) {
           case SourceType.glucose:
        return 'Glukos';
         case SourceType.enteral:
        return 'Enteral nutrition';
          
      case SourceType.oral:
        return 'Peroral nutrition';
 
      case SourceType.parenteral:
        return 'Parenteral nutrition';
      case SourceType.medication:
        return 'Läkemedel';

    }
  }
}
