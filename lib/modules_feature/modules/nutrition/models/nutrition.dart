// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';



abstract class Nutrition {
  final Source source;


  Nutrition({
    required this.source,

  });

  double kcalPerDay();

  double proteinPerDay();

  double volumePerDay();

  double lipidsPerDay();


Nutrition createNewNutrition(Source source) {
  return switch (source) {
    ContinousSource c => Continuous(
      continuousSource: c,
      mlPerHour: 42,
      ),
    IntermittentSource i => Intermittent(
      intermittentSource: i,
      quantity: 1,
      ),

  };
  
}

}
