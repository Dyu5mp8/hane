import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/expanded_info/expanded_dialog.dart';
import 'package:hane/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:icons_plus/icons_plus.dart';

class NoteRow extends StatelessWidget {
  const NoteRow({super.key});

  @override
  Widget build(BuildContext context) {
    final drug =
        Provider.of<Drug>(context); // Access the drug from the Provider
    final editMode = Provider.of<EditModeProvider>(context)
        .editMode; // Access editMode from the Provider

    return Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          if ((drug.expandedNotes?.isNotEmpty ?? false) && !editMode) {
            showDialog(
              context: context,
              builder: (context) => ExpandedDialog(
                text: drug.expandedNotes!,
              ),
            );
          }
        },
        child: Row(
          children: [
            Badge(
                label: Icon(Icons.info,
                    size: 17, color: Theme.of(context).colorScheme.tertiary),
                offset: const Offset(5, -8),
                backgroundColor: Colors.transparent,
                isLabelVisible: (drug.expandedNotes?.isNotEmpty ?? false),
                child: Icon(
                  Bootstrap.chat_square_text_fill,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                )),
            const SizedBox(width: 15),
            Flexible(
              child: AbsorbPointer(
                absorbing: !editMode,
                child: EditableRow(
                  editDialog: EditNotesDialog(drug: drug, isUserNote: false),
                  isEditMode: editMode,
                  text: drug.notes,
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

