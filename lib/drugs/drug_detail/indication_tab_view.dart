import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/dosageViewHandler.dart";
import "package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/drug_detail/editable_row.dart";
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
        children: indications.map((indication) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Notes section
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditableRow(
                      nullWhenNotEditing: true,
                      isEditMode: editMode,
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      editDialog: EditIndicationDialog(
                        drug: Provider.of<Drug>(context, listen: false),
                        indication: indication,
                      ),
                      text: indication.name,
                    ),
                    if (indication.notes != null && indication.notes!.isNotEmpty || editMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: EditableRow(
                          textStyle: TextStyle(
                              fontSize: 14, color: Colors.black54),
                          isEditMode: editMode,
                          editDialog: EditIndicationDialog(
                            drug: Provider.of<Drug>(context, listen: false),
                            indication: indication,
                          ),
                          text: "Anteckningar: ${indication.notes}",
                        ),
                      ),
                  ],
                ),
              ),
          
              // Dosages section
              if (indication.dosages != null)
                Flexible(
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
                          SizedBox(height: 3), // Spacing between items
                        ],
                      );
                    },
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}