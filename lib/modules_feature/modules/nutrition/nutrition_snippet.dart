import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/models/infusion.dart';
import 'package:hane/modules_feature/modules/nutrition/models/meal.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_view_model.dart';



class NutritionSnippet extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionSnippet({Key? key, required this.nutrition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Step 1: Check the runtime type
    if (nutrition is Infusion) {
      // Step 2: Cast to the correct subtype
      final infusion = nutrition as Infusion;
      // Step 3: Use a dedicated widget
      return InfusionTile(infusion: infusion);
    } 
    else if (nutrition is Meal) {
      final meal = nutrition as Meal;
      return MealTile(meal: meal);
    } 
    // Step 4: Handle "unrecognized" subtypes gracefully
    else {
      return const ListTile(
        title: Text('Unknown nutrition type'),
      );
    }
  }
}

class InfusionTile extends StatelessWidget {
  final Infusion infusion;

  const InfusionTile({Key? key, required this.infusion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(infusion.source.name),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Infusionstakt: ${infusion.getInfusionRate} ml/h"),
          Text("Kcal per day: ${infusion.kcalPerDay()}"),
          Text("Protein per day: ${infusion.proteinPerDay()}"),
        ],

        



    
      ),

      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          var vm = Provider.of<NutritionViewModel>(context, listen: false); 
          infusion.updateInfusionRate(infusion.mlPerHour + 10);
          print("totalKcalPerDay: ${infusion.kcalPerDay()}");
        },
      ),
    );
  }
}
class MealTile extends StatelessWidget {
  final Meal meal;

  const MealTile({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the NutritionViewModel if needed for further updates
    final viewModel = Provider.of<NutritionViewModel>(context, listen: false);

    return ListTile(
      title: Text(meal.source.name),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Kcal per day: ${meal.kcalPerDay()}"),
          Text("Protein per day: ${meal.proteinPerDay()}"),
        ],  
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // shrink to content width
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              viewModel.decreaseQuantity(meal); 
              
            },
          ),
          Text('${meal.quantity}'), // display current count
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              viewModel.increaseQuantity(meal);
              // Update the view model if necessary, e.g. notifyListeners or similar logic
            
            },
          ),
        ],
      ),
    );
  }
}