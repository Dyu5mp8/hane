import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/user_status.dart';


class OverviewBox extends StatelessWidget {
  const OverviewBox({super.key});

  @override
  Widget build(BuildContext context) {
    
    print("building OverviewBox");
    DrugListProvider provider = Provider.of<DrugListProvider>(context, listen: false);
    Drug drug = Provider.of<Drug>(context, listen: false);
    bool shouldShowUserNotes = (provider.userMode == UserMode.syncedMode && drug.changedByUser==false);

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BasicInfoRow(),
              NoteRow(),
              Divider(indent: 10, endIndent: 10, thickness: 1),
              ContraindicationRow(),
          
              if (shouldShowUserNotes)
              Divider(indent: 10, endIndent: 10, thickness: 1),
              if (shouldShowUserNotes)
              UserNoteRow(),
              SizedBox(height: 10,)
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
    print("building BasicinfoRow box");

    return Consumer<Drug>(
      builder: (context, drug, child) {
        // Use only the Drug object here
        final concentrations = drug.concentrations;

        Text _buildBrandNamesText() {
          if (drug.brandNames == null || drug.brandNames!.isEmpty) {
            return const Text(''); // No brand names, return empty widget
          }

          List<dynamic> brandNames = drug.brandNames!;
          String? genericName = drug.genericName;

          List<TextSpan> textSpans = [];

          for (var name in brandNames) {
            textSpans.add(TextSpan(
              text: name,
              style: name == genericName
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      fontStyle: FontStyle.italic)
                  : const TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
            ));

            if (name != brandNames.last) {
              textSpans.add(const TextSpan(text: ', '));
            }
          }

          return Text.rich(TextSpan(children: textSpans));
        }

        return Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          width: MediaQuery.sizeOf(context).width,
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
                    Consumer<EditModeProvider>(
                      builder: (context, editModeProvider, child) {
                        return EditableRow(
                            text: drug.name!,
                            editDialog: EditNameDialog(drug: drug),
                            isEditMode: editModeProvider.editMode,
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge);
                      },
                    ),
                    if (drug.brandNames != null)
                      Flexible(
                        child: _buildBrandNamesText(),
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
                          Consumer<EditModeProvider>(
                            builder: (context, editModeProvider, child) {
                              return EditableRow(
                                text: "Spädningar",
                                textStyle: Theme.of(context).textTheme.bodySmall,
                                editDialog:
                                    EditConcentrationsDialog(drug: drug),
                                isEditMode: editModeProvider.editMode,
                              );
                            },
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
      },
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
      width: MediaQuery.sizeOf(context).width,
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
      width: MediaQuery.sizeOf(context).width,
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
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(5),
      child: Row(children: [
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           IconButton(
               
               icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            EditNotesDialog(drug: drug, isUserNote: true, onUserNotesSaved: () {
                              // Update the user notes in the database
                              Provider.of<DrugListProvider>(context, listen: false)
                                  .addUserNotes(drug.id!, drug.userNotes ?? "");
                            }),
                      );
                    },
                  ),

         ],
       ),
            

        const SizedBox(width: 10),
        Flexible(fit: FlexFit.loose, child: Text(drug.userNotes ?? "")),
      ]),
    );
  }
}
