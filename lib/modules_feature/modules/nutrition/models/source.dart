import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';

sealed class Source {
  String? id; // Define id in the base class
  String get name;
  SourceType get type;

  Source(this.id); // Superclass constructor to initialize id

  double get kcalPerMl;
  double get proteinPerMl;
  double get lipidsPerMl;

  List<String> get displayContents;

  Map<String, dynamic> toJson();

  factory Source.fromJson(Map<String, dynamic> json, String? id) {
    final flow = json['source'];
    final type = SourceType.fromJson(json);

    switch (flow) {
      case "intermittent":
        return IntermittentSource(
          id: id,
          name: json['name'] as String,
          type: type,
          mlPerUnit: (json['mlPerUnit'] as num).toDouble(),
          kcalPerUnit: (json['kcalPerUnit'] as num).toDouble(),
          proteinPerUnit: (json['proteinPerUnit'] as num).toDouble(),
          lipidsPerUnit: (json['lipidsPerUnit'] as num).toDouble(),
        );
      case "continuous":
        return ContinousSource(
          id: id,
          name: json['name'] as String,
          type: type,
          kcalPerMl: (json['kcalPerMl'] as num).toDouble(),
          proteinPerMl: (json['proteinPerMl'] as num).toDouble(),
          lipidsPerMl: (json['lipidsPerMl'] as num).toDouble(),
          rateRangeMin: (json['rateRangeMin'] as num?)?.toDouble(),
          rateRangeMax: (json['rateRangeMax'] as num?)?.toDouble(),
        );
      default:
        throw Exception("Unknown source type: $type");
    }
  }
}

class IntermittentSource extends Source {
  @override
  final String name;
  @override
  final SourceType type;

  final double mlPerUnit;
  final double kcalPerUnit;
  final double proteinPerUnit;
  final double lipidsPerUnit;

  IntermittentSource({
    String? id, // Named parameter for id
    required this.name,
    required this.type,
    required this.mlPerUnit,
    required this.kcalPerUnit,
    required this.proteinPerUnit,
    required this.lipidsPerUnit,
  }) : super(id); // Pass id to the superclass

  /// Calculate `kcalPerMl` from `kcalPerUnit` / `mlPerUnit`.
  @override
  double get kcalPerMl => kcalPerUnit / mlPerUnit;

  /// Calculate `proteinPerMl` from `proteinPerUnit` / `mlPerUnit`.
  @override
  double get proteinPerMl => proteinPerUnit / mlPerUnit;

  /// Calculate `lipidsPerMl` from `lipidsPerUnit` / `mlPerUnit`.
  @override
  double get lipidsPerMl => lipidsPerUnit / mlPerUnit;

  @override
  List<String> get displayContents {
    return [
      "$mlPerUnit ml/enhet",
      "Kcal/enhet: $kcalPerUnit",
      "Protein/enhet: $proteinPerUnit",
      "Lipids/enhet: $lipidsPerUnit",
    ];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': "intermittent",
      'type': type.name, // Use type.name for consistency
      'mlPerUnit': mlPerUnit,
      'kcalPerUnit': kcalPerUnit,
      'proteinPerUnit': proteinPerUnit,
      'lipidsPerUnit': lipidsPerUnit,
    };
  }
}

class ContinousSource extends Source {
  @override
  final String name;
  @override
  final SourceType type;

  final double _kcalPerMl;
  final double _proteinPerMl;
  final double _lipidsPerMl;

  final double? rateRangeMin;
  final double? rateRangeMax;

  ContinousSource({
    String? id, // Named parameter for id
    required this.name,
    required this.type,
    required double kcalPerMl,
    required double proteinPerMl,
    required double lipidsPerMl,
    this.rateRangeMin = 0,
    this.rateRangeMax = 100,
  })  : _kcalPerMl = kcalPerMl,
        _proteinPerMl = proteinPerMl,
        _lipidsPerMl = lipidsPerMl,
        super(id); // Pass id to the superclass

  @override
  double get kcalPerMl => _kcalPerMl;

  @override
  double get proteinPerMl => _proteinPerMl;

  @override
  double get lipidsPerMl => _lipidsPerMl;

  @override
  List<String> get displayContents {
    return [
      "Kcal/ml: $_kcalPerMl",
      "Protein/ml: $_proteinPerMl",
      "Lipider/ml: $_lipidsPerMl",
    ];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': "continuous",
      'type': type.name,
      'kcalPerMl': _kcalPerMl,
      'proteinPerMl': _proteinPerMl,
      'lipidsPerMl': _lipidsPerMl,
      'rateRangeMin': rateRangeMin,
      'rateRangeMax': rateRangeMax,
    };
  }
}