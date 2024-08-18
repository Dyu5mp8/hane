import 'package:hane/medications/models/medication.dart';
import 'package:flutter/material.dart';
import 'package:hane/medications/views/medication_detail_view/indicationBox.dart';
import 'package:hane/medications/views/medication_detail_view/overviewBox.dart';
import 'package:provider/provider.dart';
class MedicationDetailView extends StatelessWidget {
  final Medication medication;

  const MedicationDetailView({super.key, required this.medication});

  



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
            

            const IndicationBox()
          ],
        ),
      ),
    );
  }
}