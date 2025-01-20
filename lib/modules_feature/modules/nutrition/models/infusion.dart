import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

class Infusion extends Nutrition {
  final InfusionSource infusionSource;

  double mlPerHour;

  Infusion({
    required this.infusionSource,
    required this.mlPerHour,
  }) : super(source: infusionSource);

  @override
  double kcalPerDay() {
    // Example: (mL/hour) * (kcal/mL) * 24h
    return mlPerHour * infusionSource.kcalPerMl * 24;
  }

  @override
  double proteinPerDay() {
    // Example: (mL/hour) * (protein/mL) * 24h
    return mlPerHour * infusionSource.proteinPerMl * 24;
  }

  double volumePerDay() {
    return mlPerHour * 24;
  }

  double getInfusionRate() {
    return mlPerHour;
  }

  void updateInfusionRate(double mlPerHour) {
    this.mlPerHour = mlPerHour;
  }

}