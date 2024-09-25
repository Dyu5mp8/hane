import 'package:flutter/services.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview_box.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/user_status.dart';

class DrugDetailView extends StatefulWidget {
  final bool isNewDrug;

  const DrugDetailView({super.key, this.isNewDrug = false});

  @override
  State<DrugDetailView> createState() => _DrugDetailViewState();
}

class _DrugDetailViewState extends State<DrugDetailView> {
  late final Drug _editableDrug;
  @override
  void initState() {
    super.initState();
    _editableDrug = Provider.of<Drug>(context, listen: false);

    //open dialog for new drug if that is the case
    Future.delayed(const Duration(milliseconds: 300), () {
      if (widget.isNewDrug) {
        Provider.of<EditModeProvider>(context, listen: false).toggleEditMode();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EditNameDialog(drug: _editableDrug, isNewDrug: true);
          },
        );
      }
    });
  }

  // void rese

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_editableDrug.name ?? 'Drug Details'),
        centerTitle: true,
        actions: [
          if (!_editableDrug.changedByUser) 
            InfoButton(),
          if (_editableDrug.changedByUser ||
              Provider.of<DrugListProvider>(context, listen: false).userMode ==
                  UserMode.isAdmin)
            const EditModeButton(),
        ],
      ),
      body: const Column(
        children: <Widget>[OverviewBox(), IndicationBox()],
      ),
    );
  }
}


//Appbar elements


class BackButton extends StatelessWidget {
  const BackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final editModeProvider =
            Provider.of<EditModeProvider>(context, listen: false);

        if (editModeProvider.editMode) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Ej sparade ändringar'),
                content: const Text(
                    'Är du säker på att du vill stänga utan att avsluta redigeringen?'),
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
class InfoButton extends StatelessWidget {
  InfoButton({super.key});  

  @override
  Widget build(BuildContext context) {
    Drug drug = Provider.of<Drug>(context, listen: false); // Get the drug object
    bool editMode = Provider.of<EditModeProvider>(context).editMode; // Get the editMode boolean
    String? reviewedBy = drug.reviewedBy; // Get the reviewedBy string
    bool isAdmin = Provider.of<DrugListProvider>(context, listen: false).userMode == UserMode.isAdmin;

    // Initialize the TextEditingController with the current value of 'reviewedBy'
    TextEditingController _reviewedByController = TextEditingController(text: reviewedBy ?? '');

    return IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Info'),
              content: isAdmin && editMode
                  ? SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          TextField(
                            controller: _reviewedByController,
                            decoration: const InputDecoration(
                              labelText: 'Senast granskad av:',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              drug.reviewedBy = _reviewedByController.text;
                              drug.updateDrug();
                              Navigator.pop(context);
                            },
                            child: const Text("Spara text"),
                          ),
                        ],
                      ),
                    )
                  : reviewedBy != null && reviewedBy.isNotEmpty
                      ? SizedBox(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Senast granskad av:'),
                              Text(reviewedBy),
                            ],
                          ),
                        )
                      : const Text('Ej granskat ännu.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Stäng'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class EditModeButton extends StatelessWidget {
  const EditModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    Drug drug = Provider.of<Drug>(context, listen: false);
    DrugListProvider provider =
        Provider.of<DrugListProvider>(context, listen: false);
    return Consumer<EditModeProvider>(
      builder: (context, editModeProvider, child) {
        var editMode = editModeProvider.editMode;

        return Row(
          children: [
            // Conditionally show delete button only when in edit mode
            if (editMode)
              IconButton(
                icon: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 134, 9, 0)),
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
                                  .deleteDrug(drug);

                              Navigator.pop(context); // Close dialog
                              Navigator.pop(
                                  context); // Go back to previous screen
                            },
                            child: const Text('Radera',
                                style: TextStyle(color: Colors.red)),
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
                  provider.addDrug(Provider.of<Drug>(context, listen: false));
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
