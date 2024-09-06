import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_concentrations_dialog.dart';
import 'package:hane/drugs/drug_detail/edit_contraindications_dialog.dart';
import 'package:hane/drugs/drug_detail/edit_name_dialog.dart';
import 'package:hane/drugs/drug_detail/edit_notes_dialog.dart';
import 'package:hane/drugs/drug_detail/editable_row.dart';
import 'package:hane/drugs/drug_edit/drug_detail_form.dart';
import 'package:hane/drugs/drug_edit/drug_edit_detail.dart';
import 'package:hane/drugs/models/drug.dart';


import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/ui_components/edit_button.dart';




class OverviewBox extends StatefulWidget {
  const OverviewBox({super.key});

  @override
  State<OverviewBox> createState() => _OverviewBoxState();
}

class _OverviewBoxState extends State<OverviewBox> {

  bool editMode = false;
  
  Widget basicInfoRow(BuildContext context, Drug drug) {

    List<Concentration>? concentrations = drug.concentrations;

    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (drug.categories != null)
                ...drug.categories!.map((dynamic category) {
                  return Text("#$category ",
                      style: Theme.of(context).textTheme.displaySmall);
                })
            ]),
            Row(children: [
              Flexible(
                child: EditableRow(
                  text: drug.name!,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  editDialog: EditNameDialog(drug: drug),
                  isEditMode: editMode),
              ),
  
              IconButton(
                  icon: const Icon(Icons.delete, color: Color.fromARGB(255, 122, 0, 0)),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Vill du ta bort läkemedlet?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Avbryt")),
                            TextButton(
                                onPressed: () {
                                  var drugListProvider =
                                      Provider.of<DrugListProvider>(
                                          context,
                                          listen: false);
                                  Navigator.of(context).pop();
                                  drugListProvider
                                      .deleteDrug(drug);

                                  Navigator.of(context).pop();
                                  
                                },
                                child: const Text("Ta bort"))
                          ],
                        );
                      }))
            ]),
            if (drug.brandNames != null)
              Flexible(
                child: Text(drug.brandNames!.join(", "),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontStyle: FontStyle.italic)),
              ),
          ]),
        ),
        if (concentrations != null)
          Align(
            alignment: Alignment.topRight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                            child: Column(
            mainAxisSize: MainAxisSize.min, // Moved to the right place
            children: [
              EditableRow(
                text: "Spädningar",
                textStyle: Theme.of(context).textTheme.bodyLarge,
                editDialog: EditConcentrationsDialog(drug: drug),
                isEditMode: editMode,
              ),
              // Assuming you want to display concentrations below the EditableRow
              ...drug
                .getConcentrationsAsString()!
                .map((conc) => Text(conc))
                .toList(),
            ],
          ),
                ),
              ),
            ),
          )
      ]),
    );
  }

  Widget contraindicationRow(BuildContext context, Drug drug) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,  // Align vertically if text wraps
      children: [
        Icon(Icons.warning, color: Color.fromARGB(255, 122, 0, 0)),
        SizedBox(width: 10),
        Container(
          width: MediaQuery.of(context).size.width - 70,
          child: EditableRow(
            text: drug.contraindication!,
            textStyle: const TextStyle(fontSize: 14),
            editDialog: EditContraindicationsDialog(drug: drug),
            isEditMode: editMode,
          ),
        ),
      ],
    ),
  );
}
  // Widget brandNameRow(BuildContext context, Drug drug) {
  Widget noteRow(BuildContext context, Drug drug) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(Icons.notes),
                        const SizedBox(width: 10,),
          Expanded(
            child: EditableRow(
                    text: drug.notes!,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    editDialog: EditNotesDialog(drug: drug),
                    isEditMode: editMode),
          ) 
   
        
                  
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Drug>(
      builder: (context, drug, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 350,
          ),
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              children: [
                basicInfoRow(context, drug),
                noteRow(context, drug),
                const Divider(indent: 10, endIndent: 10, thickness: 1),
                contraindicationRow(context, drug),
                const SizedBox(height: 20),
              ],
            ),
          )),
        );
      },
    );
  }
}
