import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/views/medication_list_view/medication_list_row.dart';
import 'package:hane/utils/error_alert.dart';

class MedicationListView extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<MedicationListView> {
  final String user = 'master';
 
  List<Medication> medications = [];
  @override
  void initState() {
    super.initState();
    getMedications(forceFromServer: false);
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
    
    // Search field
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
        
        title: Text('Läkemedel'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicationEditDetail(
                  medicationForm: MedicationForm(
                    medication: Medication()),))
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(

        onRefresh: refreshList,
        child: Column(children: [
          searchField,
          Expanded(child: scrollableList),

        
        ],),
      )
      
    );
  }


Future<void> refreshList() async { 
  await getMedications(forceFromServer: true);
}

  // Fetch medications from Firestore
Future<void> getMedications({bool forceFromServer = true}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var medicationsCollection = db.collection("users").doc(user).collection("medications");
  var source = forceFromServer ? Source.server : Source.cache;

  try {
    // Attempt to get the medications from the cache
    var snapshot = await medicationsCollection.get(GetOptions(source: source));

    if (snapshot.metadata.isFromCache && forceFromServer == true) {
      showErrorDialog(context,  "Kunde inte hämta ny data från servern. Försök igen senare.");
    }   

    // Check if the snapshot has any documents; if not, fetch from the server
    if (snapshot.docs.isEmpty) {
      print("No data in cache. Fetching from server.");
      snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
    }

  
    // Update state with medications, whether from cache or server
    setState(() {
  
      medications = List.from(snapshot.docs.map((doc) => Medication.fromFirestore(doc.data())));
    });
  } catch (e) {
    // If fetching from the cache fails, fetch from the server
    var snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
    setState(() {
      
      medications = List.from(snapshot.docs.map((doc) => Medication.fromFirestore(doc.data())));
    });
  }
}

}


