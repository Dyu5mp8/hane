import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/ui_components/add_indication_button.dart';
import 'package:hane/drugs/models/drug.dart';
import 'ui_components/dosage_list.dart';

class IndicationTabView extends StatelessWidget {
  const IndicationTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final drug = context.watch<Drug>();
    final editMode = context.watch<EditModeProvider>().editMode;

    if ((drug.indications == null || drug.indications!.isEmpty) &&
        drug.changedByUser) {
      return Column(
        mainAxisSize:
            MainAxisSize.min, // Shrinks the column to fit its children
        children: [
          Image.asset('assets/images/confused.png',
              height: 200, fit: BoxFit.fill),
          Text(
            "Inga indikationer ännu!",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          const Expanded(child: SizedBox(height: 10)),
          const AddIndicationButton(),
          const Expanded(child: SizedBox(height: 20)),
        ],
      );
    }

    return TabBarView(
      children: drug.indications!.map((indication) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Notes section
            if (indication.notes != null && indication.notes!.isNotEmpty)
              Container(
                width: double.infinity,
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
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DosageList(
                      drug: drug,
                      dosages: indication.dosages!,
                      editMode: editMode,
                    ),
                    // Floating action button for editing the indication
                    if (editMode)
                      Positioned(
                        bottom: 20,
                        right: 20,
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
    );
  }
}
