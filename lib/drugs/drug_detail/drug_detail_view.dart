import 'package:flutter/services.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview_box.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class DrugDetailView extends StatefulWidget {
  final Drug drug;
  final bool isNewDrug;

  const DrugDetailView({super.key, required this.drug, this.isNewDrug = false});

  @override
  State<DrugDetailView> createState() => _DrugDetailViewState();
}

class _DrugDetailViewState extends State<DrugDetailView> {

 late Drug _editableDrug;
@override
  void initState() {
    super.initState();

      _editableDrug = Drug.from(widget.drug); 

      //open dialog for new drug if that is the case
    Future.delayed(const Duration(milliseconds: 300), () {
      if (widget.isNewDrug) {
        _showNewDrugDialog();
      }
    });
  }

  // void reset

  void _showNewDrugDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNameDialog(drug: _editableDrug);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<Drug>.value(value: _editableDrug), // sets the editable drug as the provider drug
      ChangeNotifierProvider<EditModeProvider>.value(value: EditModeProvider()) // a provider for the edit mode
    ],
     
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(widget.drug.name ?? 'Drug Details'),
          centerTitle: true,
          actions: [
       
            const EditModeButton(),
          ],
        ),
        body: const Column(
          children: <Widget>[
            OverviewBox(),
            IndicationBox()
          ],
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  // final Function() onPress;
  const BackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final editModeProvider = Provider.of<EditModeProvider>(context, listen: false);

        if (editModeProvider.editMode) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Ej sparade ändringar'),
                content: const Text('Är du säker på att du vill stänga utan att avsluta redigeringen?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      
                    },
                    child: const Text('Nej'),
                  ),
                  TextButton(
                    onPressed: () {
                      
                      
                      Navigator.pop(context); // Close the dialog
                      editModeProvider.toggleEditMode();
                      Navigator.pop(context); // Go back to the previous screen
              
                    },
                    child: const Text('Ja'),
                    
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.pop(context); // Go back to the previous screen
        }
      },
    );
  }
}


class EditModeButton extends StatelessWidget {
  const EditModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditModeProvider>(
      builder: (context, editModeProvider, child) {
        var editMode = editModeProvider.editMode;

        return Row(
          children: [
            // Conditionally show delete button only when in edit mode
            if (editMode)
              IconButton(
                icon: const Icon(Icons.delete, color: Color.fromARGB(255, 134, 9, 0)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Radera'),
                        content: const Text(
                            'Är du säker på att du vill radera detta läkemedel?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Avbryt'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<DrugListProvider>(context,
                                      listen: false)
                                  .deleteDrug(Provider.of<Drug>(context, listen: false));

                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Go back to previous screen
                            },
                            child: const Text('Radera', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            // Edit/Save button
            IconButton(
              icon: editMode
                  ? Text(
                      "Spara",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    )
                  : const Icon(Icons.edit_note_sharp, size: 30),
              onPressed: () {
                HapticFeedback.lightImpact();
                if (editMode) {
                  Provider.of<DrugListProvider>(context, listen: false)
                      .addDrug(Provider.of<Drug>(context, listen: false));
                }
                editModeProvider.toggleEditMode();
              },
            ),
          ],
        );
      },
    );
  }
}