import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

class Meal extends Nutrition {
  
  final OralSource oralSource;


  Meal({
    required this.oralSource,
  }) : super(source: oralSource);



  @override
  double kcalPerDay() {
    // Example calculation, adjust as necessary
    return oralSource.kcalPerUnit * quantity;
  }

  @override
  double proteinPerDay() {
    // Example calculation, adjust as necessary
    return oralSource.proteinPerUnit * quantity;
  }

@override
double volumePerDay() {
  return (oralSource.mlPerUnit ?? 0) * quantity;
}



}