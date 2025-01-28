import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

class Continuous extends Nutrition {
  final ContinousSource continuousSource;

  double mlPerHour;

  Continuous({
    required this.continuousSource,
    required this.mlPerHour,
  }) : super(source: continuousSource);

  @override
  double kcalPerDay() {
    // Example: (mL/hour) * (kcal/mL) * 24h
    return mlPerHour * continuousSource.kcalPerMl * 24;
  }

  @override
  double proteinPerDay() {
    // Example: (mL/hour) * (protein/mL) * 24h
    return mlPerHour * continuousSource.proteinPerMl * 24;
  }

  @override
  double lipidsPerDay() {
    // Example: (mL/hour) * (lipids/mL) * 24h
    return mlPerHour * continuousSource.lipidsPerMl * 24;
  }

  @override
  double volumePerDay() {
    return mlPerHour * 24;
  }

  void upDateRateFromVolume(double volumePerDay) {
    mlPerHour = volumePerDay / 24;
  }

  double getRate() {
    return mlPerHour;
  }

  void updateRate(double mlPerHour) {
    this.mlPerHour = mlPerHour;
  }

}