import 'package:flutter/material.dart';
import 'package:hane/models/medication.dart';
import 'package:hane/Views/medication_detail_view.dart';

class MedicationListRow extends StatelessWidget {
  final Medication _medication;

  MedicationListRow(this._medication);

  @override
  Widget build(BuildContext context) {
     return ListTile(
        title: Text(_medication.name??''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_medication.notes ?? ''), // Handles null by showing an empty string
            Text(_medication.notes ?? ''), // Same here
          ],
        ),
        trailing: Text((_medication.dosage ?? 0).toString()),
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
