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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        subtitle: _medication.categories != null
            ? Text(
                _medication.categories!.join(", "),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => _medication,
                child: MedicationDetailView(medication: _medication),
              ),
            ),
          );
        },
      );
    }
  }
}