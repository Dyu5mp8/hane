import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:provider/provider.dart';

class OverviewBox extends StatelessWidget {

 
  Widget basicInfoRow(BuildContext context, Medication medication) {

        return Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(medication.name!, style: Theme.of(context).textTheme.headlineLarge),
                  if (medication.category != null) Text(medication.category!)
                
                ],),
              ),
              Flexible(
                child: Column(
                
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Text("10002222222 mg/ml"),
                  Text("50,000 E/mikroliter"),
                
                ],),
              ),
            ],
          )
        );
      }

  



  Widget contraindicationRow(BuildContext context,Medication medication) {
  
      return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
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
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          padding: EdgeInsets.all(10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
            Text('Anteckningar', style: TextStyle(fontSize: 16),),
            medication.notes != null ? Text(medication.notes!) : Text(""),
          
              ElevatedButton(onPressed: (){ medication.notes = medication.name;}, child: Text("Spara"))
              ,


          ],)
        );
      }
  @override
Widget build(BuildContext context) {

    return Consumer<Medication>(
      builder: (context, medication, child) {
        return Container(
          color: Colors.white, // Assuming a more neutral background for the whole box
          child: Column(
            children: [
              basicInfoRow(context, medication),
              noteRow(context, medication),
              contraindicationRow(context, medication)
            ],
          ),
        );
      },
    );

}
}

