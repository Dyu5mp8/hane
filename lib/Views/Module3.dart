import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreExample extends StatefulWidget {
  @override
  _FirestoreExampleState createState() => _FirestoreExampleState();
}

class _FirestoreExampleState extends State<FirestoreExample> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void addMedicationData() async {
    final medications = db.collection("users")
    .doc("master")
    .collection("medications")
    ;

    final data1 = <String, dynamic>{
      "brand_name" : "Amoxil",
      "generic": "Amoxicillin",
      "max_dose": null,
      "min_dose": null,
      "fixed_dose_mg": 500,
    };
    medications.doc("amoxicillin").set(data1);

    final data2 = <String, dynamic>{
      "brand_name" : "Advil",
      "generic": "Ibuprofen",
      "max_dose": 800,
      "min_dose": 200,
      "fixed_dose_mg": null,
    };
    medications.doc("ibuprofen").set(data2);

    final data3 = <String, dynamic>{
      "brand_name" : "Glucophage",
      "generic": "Metformin",
      "max_dose": 2000,
      "min_dose": 500,
      "fixed_dose_mg": 500,
    };
    medications.doc("metformin").set(data3);


  }
  void addMedicationData_test() async {

  CollectionReference medications = FirebaseFirestore.instance
      .collection("users")
      .doc("master")
      .collection("medications");

  // Create sample basic medication data
  List<Map<String, dynamic>> medicationData = [
    {
      'name': 'Amoxicillin',
      'concentration': ['250mg/5ml', '500mg/5ml'],
      'contraindication': 'Allergy to penicillin',
      'adult_indications': [
        {
          'name': 'Bacterial Infection',
          'bolus': [
            {
              'instruction': 'Take one tablet twice a day',
              'administration_route': 'Oral',
              'dose': {
                'fixed': {'amount': 500, 'unit': 'mg'}
              }
            }
          ],
          'notes': 'Monitor for allergic reactions'
        }
      ],
      'notes': 'Used to treat a variety of bacterial infections'
    },
    {
      'name': 'Ibuprofen',
      'concentration': ['200mg', '400mg'],
      'adult_indications': [
        {
          'name': 'Pain Relief',
          'bolus': [
            {
              'instruction': 'Take one tablet every 4-6 hours as needed',
              'administration_route': 'Oral',
              'dose': {
                'fixed': {'amount': 400, 'unit': 'mg'}
              }
            }
          ],
          'notes': 'Do not exceed 3200 mg per day'
        }
      ],
      'notes': 'Nonsteroidal anti-inflammatory drug (NSAID)'
    }
  ];

  // Add each medication entry to Firestore
  try {
    for (var med in medicationData) {
      await medications.add(med);
      print("Medication ${med['name']} added successfully!");
    }
  } catch (e) {
    print("Error adding medications: $e");
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add medications Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addMedicationData_test,
          child: Text('Add medications to Firestore'),
        ),
      ),
    );
  }
}