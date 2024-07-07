import 'package:flutter/material.dart';
import 'package:hane/models/medication.dart';

class MedicationListRow extends StatelessWidget {
  final Medication _medication;

  MedicationListRow(this._medication);

  @override
  Widget build(BuildContext context) {
     return ListTile(
        title: Text(_medication.name??''),
        subtitle: Text(_medication.notes??''),
        trailing: Text((_medication.dosage ?? 0).toString()),
      );
  }
} 
