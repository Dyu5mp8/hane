import 'package:flutter/foundation.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/models/infusion.dart';
import 'package:hane/modules_feature/modules/nutrition/models/meal.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';

class NutritionViewModel extends ChangeNotifier {
  double patientWeight = 70;

  int day = 0;

  List<Nutrition> allNutritions = [];

  List<Infusion> get infusions => allNutritions.whereType<Infusion>().toList();

  List<Meal> get meals => allNutritions.whereType<Meal>().toList();

  setNewWeight(double weight) {
    patientWeight = weight;
    notifyListeners();
  }

  setNewDay(int newDay) {
    day = newDay;
    notifyListeners();
  }



  calculateNeeds(double requirementPerKg) {
    patientWeight * requirementPerKg;
  }



  calculateNeedBasedOnDay(int day) {

    // 25 kcal/kg/day for day 8 and above
    double requirementPerKg = day < 8 ? 20 : 25;
    return patientWeight * requirementPerKg;
  }

  double totalKcalPerDay() {
    // sum the kcal of all nutritions.
    return allNutritions.fold(
        0, (acc, nutrition) => acc + nutrition.kcalPerDay());
  }

  double totalProteinPerDay() {
    return allNutritions.fold(
        0, (acc, nutrition) => acc + nutrition.proteinPerDay());
  }

  double totalVolumePerDay() {
    return infusions.fold(0, (acc, infusion) => acc + infusion.volumePerDay());
  }

  void increaseQuantity(Nutrition nutrition) {
    nutrition.increaseQuantity();
    notifyListeners();
  }

  void decreaseQuantity(Nutrition nutrition) {
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
