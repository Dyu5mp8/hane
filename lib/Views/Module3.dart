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
      "brand_names" : ["Amoxicillin", "Moxatag"],
      "generic": "Amoxicillin",
      "max_dose": null,
      "min_dose": null,
      "fixed_dose_mg": 500,
    };
    medications.doc("amoxicillin").set(data1);

    final data2 = <String, dynamic>{
      "brand_names" : ["Advil", "Motrin"],
      "generic": "Ibuprofen",
      "max_dose": 800,
      "min_dose": 200,
      "fixed_dose_mg": null,
    };
    medications.doc("ibuprofen").set(data2);

    final data3 = <String, dynamic>{
      "brand_names" : ["Glucophage", "Glumetza"],
      "generic": "Metformin",
      "max_dose": 2000,
      "min_dose": 500,
      "fixed_dose_mg": 500,
    };
    medications.doc("metformin").set(data3);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add medications Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addMedicationData,
          child: Text('Add medications to Firestore'),
        ),
      ),
    );
  }
}