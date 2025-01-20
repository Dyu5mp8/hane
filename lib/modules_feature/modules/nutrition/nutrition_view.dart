import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/goal_slider.dart';
import 'package:hane/modules_feature/modules/nutrition/models/infusion.dart';
import 'package:hane/modules_feature/modules/nutrition/models/meal.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_snippet.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_view_model.dart';



class NutritionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NutritionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Nutrition')),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height/2,
            child: ListView.builder(
              itemCount: viewModel.allNutritions.length,
              itemBuilder: (context, index) {
                return NutritionSnippet(nutrition: viewModel.allNutritions[index]);
              },
            ),
          ),
          NutritionalScale()
          
         
     
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For demo purposes, create a new Infusion (or Meal) on-the-fly:

          final newMeal = Meal(
            oralSource: OralSource(
              name: "New Meal",
              kcalPerUnit: 100,
              proteinPerUnit: 10,
            ),
      
          );

          final newInfusion = Infusion(
            infusionSource: InfusionSource(
              name: "New Infusion",
              kcalPerMl: 1,
              proteinPerMl: 0.1,
              type: SourceType.parenteral,
            ),
            mlPerHour: 40,
          );
          // Add it to the ViewModel's list:
          viewModel.addNutrition(newMeal);
          print("totalKcalPerDay: ${viewModel.totalKcalPerDay()}");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}