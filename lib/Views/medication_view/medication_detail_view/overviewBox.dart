import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hane/models/medication/medication.dart';

class OverviewBox extends StatelessWidget {

  final String titleText;
  final String? categoryText;
  final List<String>? concentrationTextList;
  final String? contraindicationText;
  final String? noteText;

  OverviewBox({
    super.key,
    required this.titleText,
    this.categoryText,
    this.concentrationTextList,
    this.contraindicationText,
    this.noteText

  });

  Widget basicInfoRow(BuildContext context) {
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
              Text(titleText, style: Theme.of(context).textTheme.headlineLarge),
              if (categoryText != null) Text(categoryText as String)
            
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



  Widget contraindicationRow(BuildContext context) {

  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    color: Colors.red,
    padding: EdgeInsets.all(10),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
      Text("Kontraindikationer", style: TextStyle(fontSize: 16),),
      contraindicationText != null ? Text(contraindicationText!) : Text('Ingen angedd kontraindikation')
    ],)
  );
  }



  Widget noteRow(BuildContext context) {
    return
  Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      padding: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
        Text('Anteckningar', style: TextStyle(fontSize: 16),),
        noteText != null ? Text(noteText!) : Text("")

      ],)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      child: Column(
        children: [ 
        basicInfoRow(context),
        noteRow(context),
        contraindicationRow(context)
        ]
    )
    );
  }
}


    

