import 'package:flutter/material.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:hane/Views/medication_view/medication_detail_view/medication_detail_view.dart';

class MedicationListRow extends StatelessWidget {
  final Medication _medication;

  MedicationListRow(this._medication);


  @override
  Widget build(BuildContext context) {
    // If the medication name is null, return a list tile with a message.
    if (_medication.name == null){
      return const ListTile(
        
        title: Text("Felaktig data"),
      );
      }


    else {
     return ListTile(
        title: Text(_medication.name!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          if (_medication.category != null) 
          Text(_medication.category!),
    ],
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicationDetailView(medication: _medication),
            ),
          );
        }
      );
  }
  }
} 