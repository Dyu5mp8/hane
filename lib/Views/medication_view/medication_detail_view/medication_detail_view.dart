import 'package:hane/models/medication/medication.dart';
import 'package:flutter/material.dart';
import 'package:hane/Views/medication_view/medication_detail_view/indicationBox.dart';
import 'package:hane/Views/medication_view/medication_detail_view/indication_tab.dart';
import 'package:hane/Views/medication_view/medication_detail_view/overviewBox.dart';


class MedicationDetailView extends StatelessWidget {
  final Medication medication;

  MedicationDetailView({required this.medication});



  @override
  Widget build(BuildContext context) {
    print(medication.concentration);
    print(medication.contraindication); 

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name!),
      ),
      body: Column(
        children: <Widget>[
          OverviewBox(
            titleText: medication.name!,
            categoryText: medication.category,
            concentrationTextList: medication.concentration,
            contraindicationText: medication.contraindication,
            noteText: medication.notes),
          IndicationTab(),
          IndicationBox(),
        ],
      )
    );
  }
  
}

