import 'package:hane/models/medication/medication.dart';
import 'package:flutter/material.dart';
import 'package:hane/Views/medication_view/medication_detail_view/indicationBox.dart';
import 'package:hane/Views/medication_view/medication_detail_view/indication_tab.dart';
import 'package:hane/Views/medication_view/medication_detail_view/overviewBox.dart';
import 'package:provider/provider.dart';
class MedicationDetailView extends StatelessWidget {
  final Medication medication;

  MedicationDetailView({required this.medication});

  



  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider<Medication>.value(
      value: medication,
      child: Scaffold(
        appBar: AppBar(
          title: Text(medication.name ?? 'Medication Details'),
        ),
        body: Column(
          children: <Widget>[
            OverviewBox(),

           if (medication.adultIndications != null && medication.adultIndications!.isNotEmpty) 
            IndicationBox()
          ],
        ),
      ),
    );
  }
}