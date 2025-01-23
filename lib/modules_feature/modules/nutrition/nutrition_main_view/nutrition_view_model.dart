import 'package:flutter/foundation.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';

class NutritionViewModel extends ChangeNotifier {
  double patientWeight = 70;
  double patientLength = 180;

  int day = 0;

  List<Nutrition> allNutritions = [];

  List<Continuous> get infusions => allNutritions.whereType<Continuous>().toList();

  List<Intermittent> get meals => allNutritions.whereType<Intermittent>().toList();

  setNewWeight(double weight) {
    patientWeight = weight;
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



  calculateNeeds(double requirementPerKg) {
   idealWeight() * requirementPerKg;
  }



  calculateNeedBasedOnDay(int day) {

    // 25 kcal/kg/day for day 8 and above
    double requirementPerKg = day < 8 ? 20 : 25;
    return patientWeight * requirementPerKg;
  }


  double get bmi => patientWeight / (patientWeight * patientWeight / 10000);

  double idealWeight() {
    if (bmi < 25){

      return patientWeight;
    }
    return (patientLength - 100) + 0.25 * (patientWeight - (patientLength - 100)); 
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
