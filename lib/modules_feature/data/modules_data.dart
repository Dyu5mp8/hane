import 'package:flutter/material.dart' show Icons;

import 'package:hane/modules_feature/models/module.dart';
import 'package:hane/modules_feature/modules/antibiotics/antibiotic_list_view.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_view.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/rotem/rotem_view.dart';
import 'package:provider/provider.dart';




List<Module> modules = 

[
    Module(
      id: 'dialysis',
      name: 'Dialys',
      description: 'Kalkylator för dialys',
      icon: Icons.calculate,
      moduleDetailView: DialysisView(),

    ),

    Module(
      id: 'rotem',
      name: 'ROTEM',
      description: 'Stöd för tolkning av ROTEM',
      icon: Icons.bloodtype,
      moduleDetailView: RotemWizardScreen()
    ),

    Module(
      id: 'nutrition',
      name: 'Nutrition',
      description: 'Kalkylator för nutrition IVA',
      icon: Icons.food_bank,
      moduleDetailView: ChangeNotifierProvider(
        create: (_) => NutritionViewModel(),
        child: NutritionView(),
      )
    ),

    Module(
      id: 'antibiotics',
      name: 'Antibiotika',
      description: 'Antibiotikalista (RAF)',
      icon: Icons.medication,
      moduleDetailView: AntibioticsListView()
    )



];