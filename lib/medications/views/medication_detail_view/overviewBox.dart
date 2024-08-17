import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/services/firebaseService.dart';
import 'package:hane/medications/services/medication_firebase_service.dart';
import 'package:hane/medications/services/medication_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:hane/medications/ui_components/editButton.dart';


class OverviewBox extends StatelessWidget {
  Widget basicInfoRow(BuildContext context, Medication medication) {
    final editButton = editButtontoView(
        destination: MedicationEditDetail(
            medicationForm: MedicationForm(
                medication: medication,
              )));

    List<Concentration>? concentrations = medication.concentrations;

    return Container(
      height: 120,
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [if (medication.categories != null) 
              ...medication.categories!.map((dynamic category) {
                return Text("#$category ", style: TextStyle(fontSize: 11));
              }).toList()]
            ),
              Row(
                children: [
                  Flexible(
                    child: Text(medication.name!,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  editButton,
                  IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Vill du ta bort läkemedlet?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Avbryt")),
                TextButton(
                    onPressed: () {
                      var medicationListProvider = Provider.of<MedicationListProvider>(context, listen: false);
                      Navigator.of(context).pop();
                      FirebaseService.deleteMedication(medicationListProvider.user, medication);
                      
                      Navigator.of(context).pop();
                      medicationListProvider.refreshList();
                    },
                    child: Text("Ta bort")

    )],
            );  
          }
      )
                  ) 

                  
        
                ]
              ),
              if (medication.brandNames != null)
                Flexible(
                  child: Text(medication.brandNames!.join(", "),
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                ),
          
      ]),
        ),
        if (concentrations != null)
          Align(
            alignment: Alignment.topRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),

              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      
                      mainAxisSize: MainAxisSize.min,
                      children: medication
                          .getConcentrationsAsString()!
                          .map((conc) => Text(conc))
                          .toList()),
                ),
              ),
            ),
          )
      ]),
    );
  }

  Widget brandNameRow(BuildContext context, Medication medication) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "namn",
              style: TextStyle(fontSize: 16),
            ),
            medication.brandNames != null
                ? Text(medication.brandNames!.join(", "))
                : Text('sss')
          ],
        ));
  }

  Widget contraindicationRow(BuildContext context, Medication medication) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kontraindikationer",
              style: TextStyle(fontSize: 16),
            ),
            medication.contraindication != null
                ? Text(medication.contraindication!)
                : Text('Ingen angedd kontraindikation')
          ],
        ));
  }

  // Widget brandNameRow(BuildContext context, Medication medication) {

  // //   implement brandNameRow
  //   }

  Widget noteRow(BuildContext context, Medication medication) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anteckningar',
              style: TextStyle(fontSize: 16),
            ),
            medication.notes != null ? Text(medication.notes!) : Text(""),
            //Testing state
            // ElevatedButton(onPressed: (){ medication.notes = medication.name;}, child: Text("Spara"))
            // ,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Medication>(
      builder: (context, medication, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 350,
          ),
          child: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                basicInfoRow(context, medication),
                noteRow(context, medication),
                contraindicationRow(context, medication)
              ],
            ),
          )),
        );
      },
    );
  }
}
