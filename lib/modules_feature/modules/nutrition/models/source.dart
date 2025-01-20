import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';

abstract class Source {
  String get name;
  SourceType get type;

}

class OralSource extends Source {
  @override
  final String name;
  @override
  final SourceType type = SourceType.oral;

  final double? mlPerUnit;

  final double? kcalPerMl;
  final double? proteinPerMl;
  final double kcalPerUnit;
  final double proteinPerUnit;

  OralSource({required this.name, required this.kcalPerUnit, required this.proteinPerUnit, this.mlPerUnit, this.kcalPerMl, this.proteinPerMl});
}

class InfusionSource extends Source {
  @override
  final String name;
  @override
  final SourceType type;

  final double? mlPerUnit;

  final double kcalPerMl;
  final double proteinPerMl;

  InfusionSource({required this.name, required this.kcalPerMl, required this.type, required this.proteinPerMl, this.mlPerUnit});
}