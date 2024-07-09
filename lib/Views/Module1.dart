import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/models/medication.dart';
import 'package:hane/Views/Helpers/medication_list_row.dart';
import 'package:hane/Services/FirestoreService.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final String user = 'master';
 
  List<Medication> medications = [];
  @override
  void initState() {
    super.initState();
    getMedications();
  }

  @override
  Widget build(BuildContext context) {
    
    final scrollableList = 
    
    SafeArea(
    child: ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        return MedicationListRow(medications[index] as Medication);
      },
    ),
    );
    
  

    return Scaffold(
      appBar: AppBar(
        title: Text('Medications List'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: medications.length,
          itemBuilder: (context, index) {
            return MedicationListRow(medications[index] as Medication);
          }
          
           )
     
  
    )
    );
  }
Future getMedications() async {
  var medicationsCollection = db.collection("users").doc(user).collection("medications");
  var snapshot = await medicationsCollection.get();

        setState(() {
          medications = List.from(snapshot.docs.map((doc) => Medication.fromSnapshot(doc)));
              });
  }

}



class ItemDetailView extends StatelessWidget {
  final Map<String, dynamic> itemDetails;

  ItemDetailView({required this.itemDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${itemDetails['name']}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: ${itemDetails['name']}', style: Theme.of(context).textTheme.headlineMedium),
            Text('Indication: ${itemDetails['indication']}', style: Theme.of(context).textTheme.labelSmall),
            Text('Dosage: ${itemDetails['dosage']}', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

