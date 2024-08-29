import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_edit/drug_detail_form.dart';
import 'package:hane/drugs/drug_edit/drug_edit_detail.dart';
import 'package:hane/drugs/models/drug.dart';

import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/ui_components/edit_button.dart';

class OverviewBox extends StatelessWidget {
  const OverviewBox({super.key});

  Widget basicInfoRow(BuildContext context, Drug drug) {
    final editButton = editButtontoView(
      icon: Icons.edit,
      iconColor: Theme.of(context).primaryColor,
        destination: DrugEditDetail(
            drugForm: DrugForm(
      drug: drug,
    )));

    List<Concentration>? concentrations = drug.concentrations;

    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 255, 255, 255),
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
                child: Text(drug.name!,
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              editButton,
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
                      mainAxisSize: MainAxisSize.min,
                      children: drug
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

  Widget contraindicationRow(BuildContext context, Drug drug) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(Icons.warning, color:Color.fromARGB(255, 122, 0, 0)),
            const SizedBox(width: 10,),
              drug.contraindication != null
            ? Expanded(child: Text(drug.contraindication!, style: const TextStyle(fontSize: 14)))
            : const Text('Ingen angedd kontraindikation')
         
          ],
        ));
  }

  // Widget brandNameRow(BuildContext context, Drug drug) {

  // //   implement brandNameRow
  //   }

  Widget noteRow(BuildContext context, Drug drug) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(Icons.notes, color: Colors.black),
                        const SizedBox(width: 10,),
                          drug.notes != null
            ? Expanded(
              child: Text(
                  drug.notes!,
                  style: const TextStyle(fontSize: 14),
                ),
            )
            : const Text(""),
        
                  
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
            color: Colors.white,
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
