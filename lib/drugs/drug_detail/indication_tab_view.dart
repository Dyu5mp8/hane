import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/dosageViewHandler.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart";
import "package:hane/drugs/models/drug.dart";




class IndicationTabView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
   final editMode = context.watch<EditModeProvider>().editMode;
    final concentrations = context.watch<Drug>().concentrations;
    final List<Indication> indications = context.watch<Drug>().indications ?? [];
    return Expanded(
      child: TabBarView(
        children: indications
            .map((indication) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                
                    
                
                      
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (editMode)
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            iconSize: 25,
                            color: Colors.black,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      if (indication.notes != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            indication.notes!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      if (indication.dosages != null)
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(1),
                            itemCount: indication.dosages?.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DosageSnippet(
                                    dosage: indication.dosages![index],
                                    dosageViewHandler: DosageViewHandler(
                                      super.key,
                                      dosage: indication.dosages![index],
                                      availableConcentrations: concentrations,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}