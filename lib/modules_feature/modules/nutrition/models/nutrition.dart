// ignore_for_file: public_member_api_docs, sort_constructors_first
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


}
