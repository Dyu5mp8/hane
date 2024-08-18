import 'package:flutter/material.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/views/medication_detail_view/medication_detail_view.dart';
import 'package:provider/provider.dart';

class MedicationListRow extends StatelessWidget {
  final Medication _medication;

  const MedicationListRow(this._medication, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_medication.name == null) {
      return const ListTile(
        title: Text(
          "Felaktig data",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        
        title: Text(
          _medication.name!,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_medication.brandNames != null)
        Text(
          _medication.brandNames!.join(","),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontStyle: FontStyle.italic, fontSize: 12),
        ),

      
    ],
  ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicationDetailView(medication: _medication),
            ),
          );
        },
      );
    }
  }
}