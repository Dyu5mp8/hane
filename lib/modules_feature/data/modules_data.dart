import 'package:flutter/material.dart' show Icons;
import 'package:hane/modules_feature/models/module.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_view.dart';
import 'package:hane/modules_feature/modules/rotem/rotem_view.dart';



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
      moduleDetailView: RotemScreen(),
    )




];