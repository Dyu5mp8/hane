import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/day_widget.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/total_protein_scale.dart';
import 'package:hane/onboarding/nutrition_tutorial.dart';
import 'package:hane/tutorial.dart';
import 'package:provider/provider.dart'; // Ensure provider is imported
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_add_views/add_nutrition_view.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/patient_data_widget.dart';

import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_snippet.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/total_energy_scale_radial.dart';

class NutritionView extends StatelessWidget with Tutorial {
  const NutritionView({Key? key}) : super(key: key);

  /// Widget to display when the nutrition list is empty
  Widget emptyListPlaceholder() {
    return Center(
      child: Text(
        'Lägg till nutritionskällor med plussymbolen nedan',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Widget to build the list of nutrition items along with the energy scale
  Widget buildNutritionList(NutritionViewModel vm, BuildContext context) {
    return Column(
      children: [
        // Mapping each nutrition item to a NutritionSnippet widget with a divider
        ...vm.allNutritions
            .map(
              (nutrition) => Column(
                children: [NutritionSnippet(nutrition: nutrition), Divider()],
              ),
            )
            .toList(),
        SizedBox(height: 20), // Spacing between the list and the energy scale
        Stack(
          children: [
            // Displaying the energy scale
            TotalEnergyScaleRadial(vm: vm),
            Positioned(
              top: 40,
              left: 40,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Vårddygn ${vm.day}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ), // Spacing between the energy scale and the bottom of the screen

        TotalProteinScale(vm: vm),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    showTutorialScreenIfNew(
      "nutritionTutorial",
      const NutritionTutorial(),
      context,
    );

    // Accessing the NutritionViewModel from the Provider
    final viewModel = Provider.of<NutritionViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text('Nutrition')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          // Displaying patient data PatientDataWidget(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SizedBox(
                  width: 330,
                  height: 140,
                  child: PatientDataWidget(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(height: 140, width: 50, child: DayWidget()),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ), // Spacing between patient data and nutrition content
          // Conditional rendering based on whether the nutrition list is empty
          viewModel.allNutritions.isEmpty
              ? emptyListPlaceholder()
              : buildNutritionList(viewModel, context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddNutritionView()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
