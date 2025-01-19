import 'package:flutter/foundation.dart';
import 'package:hane/modules_feature/modules/nutrition/models/infusion.dart';
import 'package:hane/modules_feature/modules/nutrition/models/meal.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';


class NutritionViewModel extends ChangeNotifier {

  List<Infusion> infusions = [];
  List<Meal> meals = [];

  List<Nutrition> allNutritions() {
    return [...infusions, ...meals];
  }

  double totalKcalPerDay() {
    // sum the kcal of all nutritions.
    return allNutritions().fold(0, (acc, nutrition) => acc + nutrition.kcalPerDay());
  }

  double totalProteinPerDay() {
  return allNutritions().fold(0, (acc, nutrition) => acc + nutrition.proteinPerDay());
}

 double totalVolumePerDay() {
  return infusions.fold(0, (acc, infusion) => acc + infusion.volumePerDay());
}

void addInfusion(Infusion infusion) {
  infusions.add(infusion);
  notifyListeners();
}
void addMeal(Meal meal) {
  meals.add(meal);
  notifyListeners();
}

void removeInfusion(Infusion infusion) {
  infusions.remove(infusion);
}
void removeMeal(Meal meal) {
  meals.remove(meal);
}

void clearAll() {
  infusions.clear();
  meals.clear();
}
}
