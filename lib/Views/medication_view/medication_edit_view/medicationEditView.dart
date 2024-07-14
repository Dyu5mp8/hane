import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hane/models/medication/medication.dart';
class MedicationEditView extends StatefulWidget {
  @override
  final Medication medication; 

  MedicationEditView({required this.medication}); // Constructor with key

  State<MedicationEditView> createState() => _MedicationEditViewState();
 
}

class _MedicationEditViewState extends State<MedicationEditView> {
  
  @override
  Widget build(BuildContext context) {

  return  
    Scaffold(
      appBar: AppBar(
        title: Text(widget.medication.name!),
      ),
      body: Column(
        children: <Widget>[
          Text(widget.medication.contraindication ?? 'No contraindication'),
          // Add a form here
        ],
      ),
    );
      }

  }