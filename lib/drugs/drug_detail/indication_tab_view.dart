import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/dosageViewHandler.dart";
import "package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/drug_detail/ui_components/editable_row.dart";
import "package:hane/drugs/drug_detail/ui_components/add_indication_button.dart";
import "package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/drugs/services/drug_list_provider.dart";
import "package:hane/login/user_status.dart";
import "ui_components/dosage_list.dart";

class IndicationTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drug = context.watch<Drug>();
    final editMode = context.watch<EditModeProvider>().editMode;

    if ((drug.indications == null || drug.indications!.isEmpty) &&
        drug.changedByUser) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Shrinks the column to fit its children
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.grey[600], size: 80),
                const SizedBox(height: 20),
                Text(
                  "Inga indikationer ännu!",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Lägg till en indikation för att komma igång.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const AddIndicationButton(),
              ],
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: TabBarView(
        children: drug.indications!.map((indication) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Notes section
              if (indication.notes != null && indication.notes!.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Text(
                    indication.notes ?? '',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),

              // Dosages section
              if (indication.dosages != null)
                Flexible(
                  child: Stack(
                    children: [
                     DosageList(
                        drug: drug,
                        dosages: indication.dosages!,
                        editMode: editMode,
                      ),

                      // Floating action button for editing the indication
                      if (editMode)
                        Positioned(
                          bottom: 20, // Adjust this value to position the button vertically
                          right: 20, // Adjust this value to position the button horizontally
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditIndicationDialog(
                                    indication: indication,
                                    drug: drug,
                                    withDosages: true,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_note_sharp),
                            label: const Text('Redigera indikation'),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}