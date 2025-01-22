import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';

abstract class Source {
  String get name;
  SourceType get type;

  double get kcalPerMl;
  double get proteinPerMl;
  double get lipidsPerMl;

  List<String> get displayContents;

  Map<String, dynamic> toJson();

  factory Source.fromJson(Map<String, dynamic> json) {
    final flow = json['source'];

    final type = SourceType.fromJson(json);

    switch (flow) {
      case "intermittent":

        print(json);
        return IntermittentSource(
          name: json['name'],
          type: type,
          mlPerUnit: json['mlPerUnit'],
          kcalPerUnit: json['kcalPerUnit'],
          proteinPerUnit: json['proteinPerUnit'],
          lipidsPerUnit: json['lipidsPerUnit'],
        );
      case "continuous":
      print(flow);
      print(type);
       print(json);

        return ContinousSource(
          name: json['name'],
          type: type,
          kcalPerMl: json['kcalPerMl'],
          proteinPerMl: json['proteinPerMl'],
          lipidsPerMl: json['lipidsPerMl'],
        );

      default:
        throw Exception("Unknown source type: $type");
    }
  }
}

class IntermittentSource implements Source {
  @override
  final String name;
  @override
  final SourceType type;

  final double mlPerUnit;
  final double kcalPerUnit;
  final double proteinPerUnit;
  final double lipidsPerUnit;

  IntermittentSource(
      {required this.name,
      required this.type,
      required this.mlPerUnit,
      required this.kcalPerUnit,
      required this.proteinPerUnit,
      required this.lipidsPerUnit});

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

class ContinousSource implements Source {
  @override
  final String name;
  @override
  final SourceType type;

  // Store these fields as private variables; return via getters
  final double _kcalPerMl;
  final double _proteinPerMl;
  final double _lipidsPerMl;

  ContinousSource({
    required this.name,
    required this.type,
    required double kcalPerMl,
    required double proteinPerMl,
    required double lipidsPerMl,
  })  : _kcalPerMl = kcalPerMl,
        _proteinPerMl = proteinPerMl,
        _lipidsPerMl = lipidsPerMl;

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
      'name': name,
      'source': "continuous",
      'type': type.name,
      'kcalPerMl': _kcalPerMl,
      'proteinPerMl': _proteinPerMl,
      'lipidsPerMl': _lipidsPerMl,
    };
  }
}
