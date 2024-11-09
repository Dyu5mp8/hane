import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hane/drugs/drug_detail/commit_dialog.dart';
import 'package:hane/drugs/drug_detail/drug_chat/drug_chat.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview_box.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/user_status.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';




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
      if (widget.isNewDrug && context.mounted) {
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
    final drugListProvider = Provider.of<DrugListProvider>(context);
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(_editableDrug.name ?? 'Drug Details'),
            centerTitle: true,
            actions: [
              const ReviewButton(),
              if (drugListProvider.userMode == UserMode.isAdmin &&
                  !Provider.of<EditModeProvider>(context).editMode)
                const ChatButton(),
              if (!_editableDrug.changedByUser)
                const InfoButton(),
              if (_editableDrug.changedByUser ||
                  drugListProvider.userMode == UserMode.isAdmin)
                const EditModeButton(),
            ],
          ),
          body: const Column(
            children: [OverviewBox(), IndicationBox()],
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

class ReviewButton extends StatelessWidget {
  const ReviewButton({Key? key}) : super(key: key);

  void showReviewersModal(BuildContext context) {
    final drug = Provider.of<Drug>(context, listen: false);
    final acceptedReviewers = List<String>.from(drug.reviewerUIDs ?? []);
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);
    final availableReviewers = drugListProvider.reviewerUIDs;
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Välj granskare'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Li
                        ],
                      ), 
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: availableReviewers.entries.map((entry) {
                        final reviewerUID = entry.key;
                        final reviewerEmail = entry.value;
                        final isSelected = acceptedReviewers.contains(reviewerUID);
                        final isCurrentUser = reviewerUID == currentUserUID;
                    
                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(reviewerEmail),
                          onChanged: isCurrentUser
                              ? (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      acceptedReviewers.add(reviewerUID);
                                    } else {
                                      acceptedReviewers.remove(reviewerUID);
                                    }
                                  });
                                }
                              : null, // Disable checkbox for other users
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: isCurrentUser ? null : Colors.grey,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the drug's reviewerUIDs
                drug.reviewerUIDs = acceptedReviewers;
                // Save changes using the DrugListProvider or appropriate method
                Provider.of<DrugListProvider>(context, listen: false)
                    .addDrug(drug);
                Navigator.pop(dialogContext);
              },
              child: const Text('Spara'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Avbryt'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final drug = Provider.of<Drug>(context, listen: true);
    final acceptedReviewers = drug.reviewerUIDs ?? [];
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);
    final availableReviewers = drugListProvider.reviewerUIDs.keys.toList();

    // Determine if all reviewers have accepted
    var allReviewersAccepted = true;
    for (final reviewer in availableReviewers) {
      if (!acceptedReviewers.contains(reviewer)) {
        allReviewersAccepted = false;
        break;
      }
    }
    final icon = !allReviewersAccepted ? Icon(Bootstrap.shield_fill_exclamation, color: const Color.fromARGB(255, 183, 125, 49), size: 20,) : Icon(Bootstrap.shield_fill_check, color: Colors.green, size:20);

    return IconButton(
      icon: icon,
      onPressed: () {
        showReviewersModal(context);
      },
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final drug = Provider.of<Drug>(context, listen: true);
    return IconButton(
      icon: drug.hasUnreadMessages
          ? const Badge(
              backgroundColor: Colors.red,
              smallSize: 10,
              child: Icon(Icons.forum),
            )
          : Icon(Icons.forum),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrugChat(drug: drug)),
        );
      },
    );
  }
}

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    Drug drug =
        Provider.of<Drug>(context, listen: false); // Get the drug object
    bool editMode = Provider.of<EditModeProvider>(context)
        .editMode; // Get the editMode boolean
    String? reviewedBy = drug.reviewedBy; // Get the reviewedBy string
    bool isAdmin =
        Provider.of<DrugListProvider>(context, listen: false).userMode ==
            UserMode.isAdmin;

    // Initialize the TextEditingController with the current value of 'reviewedBy'
    TextEditingController reviewedByController =
        TextEditingController(text: reviewedBy ?? '');

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
                            controller: reviewedByController,
                            decoration: const InputDecoration(
                              labelText: 'Senast granskad av:',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              drug.reviewedBy = reviewedByController.text;
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

  void saveDrug(Drug drug, Map<String, dynamic>? comment, BuildContext context) {
    var provider = Provider.of<DrugListProvider>(context, listen: false);
    if (provider.userMode == UserMode.isAdmin) {
      if (drug.changeNotes == null) {
      drug.changeNotes = {};  

    }
    if (comment != null && comment.isNotEmpty) {
      drug.changeNotes!.addAll(comment);
    } else {
      drug.changeNotes = comment;
    }
      drug.reviewedBy = FirebaseAuth.instance.currentUser!.email;
    }
    if (drug.changeNotes == null) {
      drug.changeNotes = {};  

    }
  
    Provider.of<DrugListProvider>(context, listen: false).addDrug(drug);
  }

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
            Consumer<Drug>(builder: (context, drug, child) {
              return IconButton(
                icon: editMode
                    ? Text(
                        "Spara",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor, fontSize: 16),
                      )
                    : const Icon(Icons.edit_note_sharp, size: 30),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  if (editMode) {
                    if (await provider.checkIfDrugChanged(drug)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CommitDialog(
                          onCommit: (comment) {
                            final timestamp = DateTime.now().toIso8601String();
                      
                            final changeMap = {
                              comment: timestamp
                            };

                          
            
                            saveDrug(drug, changeMap, context);
                          },
                        );
                      },
                    );
                  }
                  editModeProvider.toggleEditMode();
                  } else {
                    editModeProvider.toggleEditMode();
                  }
              },
              );
            }),
          ],
        );
      },
    );
  }

}
