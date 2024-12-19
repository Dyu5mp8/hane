import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/expanded_info/expanded_dialog.dart';
import 'package:hane/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:icons_plus/icons_plus.dart';


class ContraindicationRow extends StatelessWidget {
  const ContraindicationRow({super.key});

  @override
  Widget build(BuildContext context) {
    final drug =
        Provider.of<Drug>(context); // Access the drug from the Provider
    final editMode = Provider.of<EditModeProvider>(context)
        .editMode; // Access editMode from the Provider

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          if (drug.expandedContraindication?.isNotEmpty ?? false) {
            showDialog(
              context: context,
              builder: (context) => ExpandedDialog(
                text: drug.expandedContraindication!,
              ),
            );
          }
        },
        child: Row(
          children: [
            Badge(
              label: Icon(Icons.info,
                  size: 17, color: Theme.of(context).colorScheme.tertiary),
              backgroundColor: Colors.transparent,
              offset: const Offset(4, -10),
              isLabelVisible:
                  ((drug.expandedContraindication?.isNotEmpty ?? false) &&
                      !editMode),
              child: const Icon(
                Bootstrap.exclamation_square_fill,
                color: Color.fromARGB(255, 194, 87, 45),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            drug.contraindication != null
                ? Flexible(
                    child: AbsorbPointer(
                      absorbing: !editMode,
                      child: EditableRow(
                        text: drug.contraindication!,
                        textStyle: const TextStyle(fontSize: 14),
                        editDialog: EditContraindicationsDialog(drug: drug),
                        isEditMode: editMode,
                      ),
                    ),
                  )
                : const Text('Ingen angedd kontraindikation'),
          ],
        ),
      ),
    );
  }
}
