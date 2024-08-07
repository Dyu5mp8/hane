import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:provider/provider.dart';
import 'package:hane/Views/medication_view/Helpers/editButton.dart';


class OverviewBox extends StatelessWidget {
  Widget basicInfoRow(BuildContext context, Medication medication) {
    final editButton = editButtontoView(
        destination: MedicationEditDetail(
            medicationForm: MedicationForm(
                medication: medication,
              )));

    List<Concentration>? concentrations = medication.concentrations;

    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(children: [
        SizedBox(
          width: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(medication.name!,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  editButton
                ],
              ),
              if (medication.brandNames != null)
                Text(medication.brandNames!.join(", "),
                    style:
                        TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              if (medication.category != null) Text(medication.category!)
            ],
          ),
        ),
        if (concentrations != null)
          Flexible(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: medication
                    .getConcentrationsAsString()!
                    .map((conc) => Text(conc))
                    .toList()),
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
