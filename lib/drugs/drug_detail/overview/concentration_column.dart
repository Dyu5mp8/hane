import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/concentration_detail_view.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/ui_components/letter_icon.dart';


class ConcentrationColumn extends StatelessWidget {
  final List<Concentration> concentrations;
  final Drug drug;
  final bool isEditMode;

  const ConcentrationColumn({super.key, 
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
        ...concentrations.map((conc) => Row(
    children: [
      if (conc.isStockSolution ?? false) const SizedBox(height: 10,child: LetterIcon(letter: "S")),
      SizedBox(width: 2,),
       
Text(
  conc.toString(),
  style: TextStyle(
    color: (conc.mixingInstructions?.isEmpty ?? true) ? null : Colors.blue,
  ),
),
      
      const SizedBox(width: 2),
      if (conc.mixingInstructions?.isNotEmpty ?? false)
        const Icon(Icons.arrow_forward_ios_outlined ,color: Colors.blue, size: 8),
    ],
  )),
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
