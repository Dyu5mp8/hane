import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:provider/provider.dart';
import 'package:hane/Views/medication_view/Helpers/editButton.dart';
import 'package:hane/Views/medication_view/medication_edit_view/medicationEditView.dart';


class OverviewBox extends StatelessWidget {

  Widget basicInfoRow(BuildContext context, Medication medication) {
    final editButton = editButtontoView(destination: MedicationEditView(medication: medication));
    List<Concentration>? concentrations = medication.concentrations;

        return Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    children: [
                      Text(medication.name!, style: Theme.of(context).textTheme.headlineLarge),
                      editButton
                      ],
                  ),
                  if (medication.category != null) Text(medication.category!)
                
                ],),
              ),
              if (concentrations != null)
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: medication.getConcentrationsAsString()!.map((conc) => Text(conc)).toList()
              ),
            )
            ]
              ),
          );
      }

  



  Widget contraindicationRow(BuildContext context,Medication medication) {
  
      return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
          Text("Kontraindikationer", style: TextStyle(fontSize: 16),),
          medication.contraindication != null ? Text(medication.contraindication!) : Text('Ingen angedd kontraindikation')
        ],)
      );
    }
  


  Widget noteRow(BuildContext context, Medication medication) {

        return Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.all(10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
            Text('Anteckningar', style: TextStyle(fontSize: 16),),
            medication.notes != null ? Text(medication.notes!) : Text(""),
          //Testing state
              // ElevatedButton(onPressed: (){ medication.notes = medication.name;}, child: Text("Spara"))
              // ,


          ],)
        );
      }
  @override
Widget build(BuildContext context) {
  

    return Consumer<Medication>(
      builder: (context, medication, child) {
        return ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 350,
              ),

              child: SingleChildScrollView(
                
                child: Container(
                        color: Colors.white, 
              
                        child: Column(
                          children: [
              basicInfoRow(context, medication),
              noteRow(context, medication),
              contraindicationRow(context, medication)
                          ],
                        ),
                      )
              ),
            );
      },
    );

}
}

