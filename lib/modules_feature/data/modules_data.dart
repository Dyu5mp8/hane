import 'package:hane/modules_feature/models/module.dart';
import 'package:hane/modules_feature/modules/antibiotics/antibiotic_list_view.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_view.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view.dart';
import 'package:hane/modules_feature/modules/rotem/rotem_view.dart';
import 'package:icons_plus/icons_plus.dart';

List<Module> modules = [
  Module(
    id: 'dialysis',
    name: 'Dialys',
    description: 'Kalkylator för dialys',
    icon: Bootstrap.calculator_fill,
    moduleDetailView: DialysisView(),
  ),
  Module(
    id: 'rotem',
    name: 'ROTEM',
    description: 'Stöd för tolkning av ROTEM',
    icon: Bootstrap.droplet,
    moduleDetailView: const RotemWizardScreen(),
  ),
  Module(
    id: 'nutrition',
    name: 'Nutrition',
    description: 'Kalkylator för nutrition IVA',
    icon: Bootstrap.speedometer,
    moduleDetailView: const NutritionView(),
  ),
  Module(
    id: 'antibiotics',
    name: 'Antibiotika',
    description: 'Antibiotikalista (RAF)',
    icon: Bootstrap.list_columns,
    moduleDetailView: const AntibioticsListView(),
  ),
];
