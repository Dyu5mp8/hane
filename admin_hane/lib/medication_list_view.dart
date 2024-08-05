import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:admin_hane/medication_list_row.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/utils/error_alert.dart';
import 'package:hane/medications/services/firebaseService.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
    FirebaseService.getMedications(user).then((value) {
      setState(() {
        medications = value;
      });
    });
    
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
    Expanded(
      child: Container(
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
      ),
    );




    return Scaffold(

      body: Column(children: [
        Row(children: [
          searchField,
          ElevatedButton(
            onPressed: () {
              refreshList();
            },
            child: Text("Uppdatera"),
          ),
          ElevatedButton(onPressed:  () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MedicationEditDetail(
                                    medicationForm: MedicationForm(
                                      medication: Medication()))),
                          );
                        }, child: Icon(Icons.add)),


        ]),
        Expanded(child: scrollableList),
      
      
      ],)
      
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


