import 'package:flutter/foundation.dart';
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/scale_zone.dart';

class NutritionViewModel extends ChangeNotifier {
  double patientWeight = 70;
  double patientLength = 180;

  double? calorimetricGoal;

  int day = 10;

  List<Nutrition> allNutritions = [];

  List<Continuous> get infusions =>
      allNutritions.whereType<Continuous>().toList();

  List<Intermittent> get meals =>
      allNutritions.whereType<Intermittent>().toList();

  setNewWeight(double weight) {
    patientWeight = weight;
    notifyListeners();
  }

  setCalorimetricGoal(double goal) {
    calorimetricGoal = goal;
    notifyListeners();
  }

  setNewLength(double length) {
    patientLength = length;
    notifyListeners();
  }

  setNewDay(int newDay) {
    day = newDay;
    notifyListeners();
  }

  double calculateNeeds() {
    if (calorimetricGoal != null) {
      return calorimetricGoal!;
    }

    return calculateNeedBasedOnDay();
  }

  List<ScaleZone?> getProteinScaleZones() {
    ScaleZone? lowRed;
    ScaleZone? lowYellow;
    ScaleZone? green;
    ScaleZone? highYellow;
    ScaleZone? highRed;

    if (day < 4) {
      lowRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0,
        maxPerWeight: 0.1,
        color: ScaleZoneColor.red,
      );
      lowYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0.1,
        maxPerWeight: 0.2,
        color: ScaleZoneColor.yellow,
      );
      green = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0.2,
        maxPerWeight: 1,
        color: ScaleZoneColor.green,
      );
      highYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1,
        maxPerWeight: 1.3,
        color: ScaleZoneColor.yellow,
      );
      highRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1.3,
        maxPerWeight: 1000,
        color: ScaleZoneColor.red,
      );
    }

    if (day >= 4 && day < 7) {
      lowRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0,
        maxPerWeight: 0.5,
        color: ScaleZoneColor.red,
      );
      lowYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0.5,
        maxPerWeight: 1,
        color: ScaleZoneColor.yellow,
      );
      green = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1,
        maxPerWeight: 1.3,
        color: ScaleZoneColor.green,
      );
      highYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1.3,
        maxPerWeight: 1.6,
        color: ScaleZoneColor.yellow,
      );
      highRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1.6,
        maxPerWeight: 1000,
        color: ScaleZoneColor.red,
      );
    }

    if (day >= 7) {
      lowRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0,
        maxPerWeight: 0.8,
        color: ScaleZoneColor.red,
      );
      lowYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0.8,
        maxPerWeight: 1.2,
        color: ScaleZoneColor.yellow,
      );
      green = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1.2,
        maxPerWeight: 1.4,
        color: ScaleZoneColor.green,
      );
      highYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1.4,
        maxPerWeight: 1.6,
        color: ScaleZoneColor.yellow,
      );
      highRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 1.6,
        maxPerWeight: 1000,
        color: ScaleZoneColor.red,
      );
    }

    return [lowRed, lowYellow, green, highYellow, highRed];
  }

  List<ScaleZone?> getCalorieScaleZones() {
    ScaleZone? lowRed;
    ScaleZone? lowYellow;
    ScaleZone? green;
    ScaleZone? highYellow;
    ScaleZone? highRed;

    if (day < 4) {
      lowYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0,
        maxPerWeight: 4,
        color: ScaleZoneColor.yellow,
      );
    }
    green = ScaleZone(
      weight: idealWeight(),
      minPerWeight: 4,
      maxPerWeight: 14,
      color: ScaleZoneColor.green,
    );
    highYellow = ScaleZone(
      weight: idealWeight(),
      minPerWeight: 14,
      maxPerWeight: 20,
      color: ScaleZoneColor.yellow,
    );
    highRed = ScaleZone(
      weight: idealWeight(),
      minPerWeight: 20,
      maxPerWeight: 1000,
      color: ScaleZoneColor.red,
    );

    if (day >= 4 && day < 7) {
      lowRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0,
        maxPerWeight: 10,
        color: ScaleZoneColor.red,
      );
      lowYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 10,
        maxPerWeight: 15,
        color: ScaleZoneColor.yellow,
      );
      green = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 15,
        maxPerWeight: 20,
        color: ScaleZoneColor.green,
      );
      highYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 20,
        maxPerWeight: 25,
        color: ScaleZoneColor.yellow,
      );
      highRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 25,
        maxPerWeight: 1000,
        color: ScaleZoneColor.red,
      );
    }

    if (day >= 7) {
      lowRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 0,
        maxPerWeight: 15,
        color: ScaleZoneColor.red,
      );
      lowYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 15,
        maxPerWeight: 20,
        color: ScaleZoneColor.yellow,
      );
      green = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 20,
        maxPerWeight: 25,
        color: ScaleZoneColor.green,
      );
      highYellow = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 25,
        maxPerWeight: 30,
        color: ScaleZoneColor.yellow,
      );
      highRed = ScaleZone(
        weight: idealWeight(),
        minPerWeight: 30,
        maxPerWeight: 1000,
        color: ScaleZoneColor.red,
      );
    }

    return [lowRed, lowYellow, green, highYellow, highRed];
  }

  double calculateNeedBasedOnDay() {
    // 25 kcal/kg/day for day 8 and above
    double requirementPerKg = day < 8 ? 20 : 25;
    return idealWeight() * requirementPerKg;
  }

  double get bmi => patientWeight / (patientLength * patientLength / 10000);

  double idealWeight() {
    if (bmi < 25) {
      return patientWeight;
    }

    var idealWeight =
        (patientLength - 100) + 0.25 * (patientWeight - (patientLength - 100));

    return idealWeight;
  }

  double totalKcalPerDay() {
    // sum the kcal of all nutritions.
    return allNutritions.fold(
      0,
      (acc, nutrition) => acc + nutrition.kcalPerDay(),
    );
  }

  double totalProteinPerDay() {
    return allNutritions.fold(
      0,
      (acc, nutrition) => acc + nutrition.proteinPerDay(),
    );
  }

  double totalVolumePerDay() {
    return infusions.fold(0, (acc, infusion) => acc + infusion.volumePerDay());
  }

  void updateRate(Continuous nutrition, double newRate) {
    nutrition.updateRate(newRate);
    notifyListeners();
  }

  void increaseQuantity(Intermittent nutrition) {
    nutrition.increaseQuantity();
    notifyListeners();
  }

  void decreaseQuantity(Intermittent nutrition) {
    nutrition.decreaseQuantity();
    notifyListeners();
  }

  void addNutrition(Nutrition nutrition) {
    allNutritions.add(nutrition);
    notifyListeners();
  }

  void removeNutrition(Nutrition nutrition) {
    allNutritions.remove(nutrition);
    notifyListeners();
  }

  void clearAll() {
    infusions.clear();
    meals.clear();
  }
}
