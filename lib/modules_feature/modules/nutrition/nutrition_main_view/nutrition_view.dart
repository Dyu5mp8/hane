import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_add_views/add_nutrition_view.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/patient_data_widget.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/total_energy_scale.dart';
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_snippet.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/total_energy_scale_radial.dart';


class NutritionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NutritionViewModel>(context);
    print("NutritionView build");
    print("viewModel.allNutritions.length: ${viewModel.allNutritions.length}");

    return Scaffold(
      appBar: AppBar(title: Text('Nutrition')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: PatientDataWidget(),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.allNutritions.length,
              itemBuilder: (context, index) {
                return NutritionSnippet(nutrition: viewModel.allNutritions[index]);
              },
            ),
          ),

          TotalEnergyScaleRadial(vm: viewModel),
          
         
     
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNutritionView(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}