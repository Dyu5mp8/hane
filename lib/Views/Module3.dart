import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:hane/models/medication/indication.dart';
import 'package:hane/models/medication/bolus_dosage.dart';
import 'package:hane/models/medication/continuous_dosage.dart';
import 'package:hane/models/medication/dose.dart';
import 'package:flutter/material.dart';
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
      name: "amoxicillin",
      concentration: ["500mg", "250mg"],
      adultIndications: [
        Indication(
          name: "Bacterial Infection",
          bolus: [
            BolusDosage(
              instruction: "Take one tablet every 8 hours",
              
              dose: {'fixed': Dose(amount: 500.0, unit: 'mg')},
              weightBasedDose: {'max': Dose(amount: 1000.0, unit: 'mg')},
            )
          ],
          notes: "Complete full prescription even if feeling better"
        )
      ],
      notes: "Used to treat a wide variety of bacterial infections."
    ),
    
    // Medication 2: Includes both adult and pediatric indications
    Medication(
      name: "Ibuprofen",
      concentration: ["200mg"],
      adultIndications: [
        Indication(
          name: "Pain Relief",
          bolus: [
            BolusDosage(
              instruction: "Take with food or milk",
              administrationRoute: "Oral",
              dose: {'fixed': Dose(amount: 400.0, unit: 'mg')},
              weightBasedDose: {'max': Dose(amount: 800.0, unit: 'mg')},
            )
          ],
          notes: "Avoid exceeding 3200 mg per day."
        )
      ],
      pedIndications: [
        Indication(
          name: "Fever Reduction",
          bolus: [
            BolusDosage(
              instruction: "Use measuring spoon or cup",
              administrationRoute: "Oral",
              dose: {'fixed': Dose(amount: 200.0, unit: 'mg')},
            )
          ],
          notes: "Consult doctor for children under 6 months."
        )
      ],
      notes: "Can cause stomach upset, take with food or milk."
    ),

    // Medication 3: More complex case with multiple doses and continuous dosage
    Medication(
      name: "Diazepam",
      concentration: ["5mg/ml"],
      adultIndications: [
        Indication(
          name: "Anxiety Relief",
          infusion: [
            ContinuousDosage(
              instruction: "Administer slowly over 3 hours",
              administrationRoute: "IV",
              dose: {'fixed': Dose(amount: 10.0, unit: 'mg')},
              weightBasedDose: {'min': Dose(amount: 0.2, unit: 'mg/kg')},
              timeUnit: "hour"
            )
          ],
          notes: "Monitor patient's respiratory function"
        )
      ],
      notes: "Use caution with other CNS depressants."
    )
  ];

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
          Text(medication.name + medication.adultIndications[0].name),

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
    print("Error adding medications: $e");
  }
}
}