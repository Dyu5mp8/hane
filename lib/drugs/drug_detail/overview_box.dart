import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';

class OverviewBox extends StatelessWidget {
  const OverviewBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              BasicInfoRow(),
              NoteRow(),
              Divider(indent: 10, endIndent: 10, thickness: 1),
              ContraindicationRow(),
              // Divider(indent: 10, endIndent: 10, thickness: 1),
              // UserNoteRow(),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BasicInfoRow extends StatelessWidget {
  const BasicInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editMode = context.watch<EditModeProvider>().editMode;
    final Drug drug = context.watch<Drug>();
    final concentrations = drug.concentrations;

    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (drug.categories != null)
                  Row(
                    children: drug.categories!
                        .map((dynamic category) => Text(
                              "#$category ",
                              style: Theme.of(context).textTheme.displaySmall,
                            ))
                        .toList(),
                  ),
                EditableRow(
                  text: drug.name!,
                  editDialog: EditNameDialog(drug: drug),
                  isEditMode: editMode,
                  textStyle: Theme.of(context).textTheme.headlineLarge
                ),
                if (drug.brandNames != null)
                  Flexible(
                    child: Text(
                      drug.brandNames!.join(", "),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          if (concentrations != null)
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: FittedBox(
                  child: Column(
                    children: [
                      EditableRow(
                        text: "Spädningar",
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        editDialog: EditConcentrationsDialog(drug: drug),
                        isEditMode: editMode,
                      ),
                      ...drug
                          .getConcentrationsAsString()!
                          .map((conc) => Text(conc))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NoteRow extends StatelessWidget {
  const NoteRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drug =
        Provider.of<Drug>(context); // Access the drug from the Provider
    final editMode = Provider.of<EditModeProvider>(context)
        .editMode; // Access editMode from the Provider

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(Icons.notes),
          const SizedBox(width: 10),
          Flexible(
            child: EditableRow(
              editDialog: EditNotesDialog(drug: drug, isUserNote: false),
              isEditMode: editMode,
              text: drug.notes,
              textStyle: const TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}

class ContraindicationRow extends StatelessWidget {
  const ContraindicationRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drug =
        Provider.of<Drug>(context); // Access the drug from the Provider
    final editMode = Provider.of<EditModeProvider>(context)
        .editMode; // Access editMode from the Provider

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Color.fromARGB(255, 122, 0, 0)),
          const SizedBox(width: 10),
          drug.contraindication != null
              ? Flexible(
                  child: EditableRow(
                    text: drug.contraindication!,
                    textStyle: const TextStyle(fontSize: 14),
                    editDialog: EditContraindicationsDialog(drug: drug),
                    isEditMode: editMode,
                  ),
                )
              : const Text('Ingen angedd kontraindikation'),
        ],
      ),
    );
  }
} 


class UserNoteRow extends StatelessWidget {
  const UserNoteRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drug =
        Provider.of<Drug>(context); // Access the drug from the Provider
    final editMode = Provider.of<EditModeProvider>(context)
        .editMode; // Access editMode from the Provider

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(Icons.notes),
          const SizedBox(width: 10),
          Flexible(
            child: EditableRow(
              editDialog: EditNotesDialog(drug: drug, isUserNote: true),
              isEditMode: editMode,
              text: drug.userNotes,
              textStyle: const TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}