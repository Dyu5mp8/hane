import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/models/medication/concentration.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:hane/models/medication/indication.dart';
import 'package:hane/models/medication/bolus_dosage.dart';
import 'package:hane/models/medication/continuous_dosage.dart';
import 'package:hane/models/medication/dose.dart';
import 'package:flutter/material.dart';
import 'package:hane/models/medication/concentration.dart';
class ModuleThree extends StatefulWidget {
  @override
  State<ModuleThree> createState() => _ModuleThreeState();
}

class _ModuleThreeState extends State<ModuleThree> {
  List medications = [];

  void getMedications() {
    medications = createTestMedications();
  }
  
List<Medication> createTestMedications() {
  var medications = [
    // Medication 1: Simple case with one adult indication and minimal fields
    Medication(
      name: "milrinon",
      contraindication: "Hypotenad kardiell syrgaskons, takykardi, ",
      concentrations: [Concentration(amount: 1.0, unit: 'mg/ml'), Concentration(amount: 0.5, unit: 'mg/ml'), Concentration(amount: 0.25, unit: 'mg/ml')],
      notes: "<0,375 μg/kn β1-awdasdawdadwadawdawdawddawdawdadsdasdwdawdsdeffekt, blodtrycksstegring, ökad CO och EF.",
      indications: [
        Indication(
          name: "Cirkulatorisk chock",
          isPediatric: false,
          dosages: [
            Dosage(
              instruction: 
                  "Ge därefter kontinuerlig infusion",
              administrationRoute: "IV",
              lowerLimitDose: Dose(amount: 0.37,unit: 'mikrog/kg/min'),
              higherLimitDose: Dose(amount: 0.75, unit: 'mikrog/kg/min'),
              maxDose: Dose(amount: 1.0, unit: 'mg'),
            ),
              Dosage(
                instruction: "bolusdos initialt",
                administrationRoute: "IV",
                dose: Dose(amount: 50.0, unit: 'mikrog/kg'),
            )
          ],
        )
      ]
              

    )];
    
    // Medication 2: Includes both adult and pediatric indications



  return medications;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add medications Data'),
      ),
      body: Center(
        child: Column(children: [
           ElevatedButton(
              onPressed: () {
                setState(() {
                  // Presumably, createTestMedications is a method that returns a list of Medications
                  medications = createTestMedications(); 
                });
              },
              child: Text('Create list of medications'),
            ),
  
        for (var medication in medications) 
          Text(medication.name + medication.adultIndications[0].name + medication.indications[0].name),

        ElevatedButton(
          onPressed: uploadTestMedications,
          child: Text('upload medications to Firestore'),
        ),

        ],)
      ),
    );
  }
  Future<void> uploadTestMedications() async {
  var medications = createTestMedications();
  var db = FirebaseFirestore.instance;
  CollectionReference medicationsCollection = db.collection('users').doc('master').collection('medications');
  try {
    for (var medication in medications) {
      await medicationsCollection.doc(medication.name).set(medication.toJson());
    }
    print("All medications added successfully!");
  } catch (e) {
   
}
}
}