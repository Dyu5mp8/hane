import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/concentration_detail_view.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';

class ConcentrationColumn extends StatelessWidget {
  final List<Concentration> concentrations;
  final Drug drug;
  final bool isEditMode;

  const ConcentrationColumn({
    required this.concentrations,
    required this.drug,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        EditableRow(
          text: "Styrkor",
          textStyle: Theme.of(context).textTheme.bodySmall,
          editDialog: EditConcentrationsDialog(drug: drug),
          isEditMode: isEditMode,
        ),
        ...concentrations.map((conc) => Text(conc.toString(),
            style: TextStyle(
                color: (conc.mixingInstructions == null ||
                        conc.mixingInstructions!.isEmpty)
                    ? Colors.black
                    : Colors.blue))),
      ],
    );

    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 100),
        child: FittedBox(
          child: (!isEditMode && concentrations.any((conc) =>
                  (conc.mixingInstructions != null &&
                      conc.mixingInstructions!.isNotEmpty)))
              ? GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ConcentrationDetailView(concentrations),
                  )),
                  child: content,
                )
              : content,
        ),
      ),
    );
  }
}
