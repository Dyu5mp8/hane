import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:hane/models/medication.dart';
import 'package:hane/Views/Helpers/medication_list_row.dart';

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
    
    final searchField = 
    Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child:
      TextField(
        decoration: InputDecoration(
          isDense: true,
          
          // labelText: 'Sök',
          hintText: 'Sök efter läkemedel',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
           
            

          ),
        ),

      ),
    );

    return Scaffold(

      appBar: AppBar(
        title: Text('Medications List'),
      ),
      body: Column(children: [
        searchField,
        Expanded(child: scrollableList),
        Text("hej")

      ],)
      
    );
  }
Future<void> getMedications() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var medicationsCollection = db.collection("users").doc(user).collection("medications");

  try {
    // Attempt to get the medications from the cache
    var snapshot = await medicationsCollection.get(const GetOptions(source: Source.cache));
    // Check if the snapshot has any documents; if not, fetch from the server
    if (snapshot.docs.isEmpty) {
      snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
    }


    // Update state with medications, whether from cache or server
    setState(() {
      medications = List.from(snapshot.docs.map((doc) => Medication.fromSnapshot(doc.data())));
    });
  } catch (e) {
    // If fetching from the cache fails, fetch from the server
    var snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
    setState(() {
      medications = List.from(snapshot.docs.map((doc) => Medication.fromSnapshot(doc.data())));
    });
  }
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

