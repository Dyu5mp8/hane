import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

class Meal extends Nutrition {
  
  final OralSource oralSource;

  Meal({
    required this.oralSource,
  }) : super(source: oralSource);

  @override
  double kcalPerDay() {
    return oralSource.kcalPerUnit;
  }

  @override
  double proteinPerDay() {
    return oralSource.proteinPerUnit;  }
}