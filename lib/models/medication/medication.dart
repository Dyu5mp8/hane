import 'package:hane/models/medication/indication.dart';
class Medication {
  final String name;
  final List<String>? concentration;
  final String? contraindication;
  final List<Indication>? adultIndications;
  final List<Indication>? pedIndications;
  final String? notes;

  Medication({
    required this.name,
    this.concentration,
    this.contraindication,
    this.adultIndications,
    this.pedIndications,
    this.notes,
  });

}