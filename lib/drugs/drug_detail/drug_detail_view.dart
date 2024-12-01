import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hane/drugs/drug_detail/change_log.dart';
import 'package:hane/drugs/drug_detail/commit_dialog.dart';
import 'package:hane/drugs/drug_detail/drug_chat/drug_chat.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/review_dialog.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview/overview_box.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/user_status.dart';
import 'package:icons_plus/icons_plus.dart';

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

    // Open dialog for new drug if that is the case
    Future.delayed(const Duration(milliseconds: 300), () {
      if (widget.isNewDrug && mounted) {
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
    final editModeProvider = Provider.of<EditModeProvider>(context);
    final editMode = editModeProvider.editMode;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_editableDrug.name ?? 'Drug Details'),
        centerTitle: true,
        actions: [
          if (!editMode && drugListProvider.isReviewer) const ReviewButton(),
          if (drugListProvider.isReviewer && !editMode)
            const ChatButton(),
          if (!_editableDrug.changedByUser && !editMode) const InfoButton(),
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
  const ReviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    final drug = Provider.of<Drug>(context, listen: true);
    final icon = !drug.hasCompletedReview()
        ? const Icon(
            Bootstrap.shield_fill_exclamation,
            color: Color.fromARGB(255, 183, 125, 49),
            size: 20,
          )
        : const Icon(Bootstrap.shield_fill_check,
            color: Colors.green, size: 20);

    return IconButton(
      icon: icon,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final currentUserUID = FirebaseAuth.instance.currentUser?.uid;
            return ReviewDialog(
              drug: drug,
              currentUserUID: currentUserUID,
            );
          },
        );
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
              child: Icon(Bootstrap.wechat),
            )
          : const Icon(Bootstrap.wechat),
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
    return IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeLog(
              drug: drug,
              onChanged: () {},
            ),
          ),
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
                icon: Icon(Icons.delete,
                   color: Color.fromARGB(255, 255, 99, 8)),  
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
                  
                            fontSize: 16),
                      )
                    : const Icon(Icons.edit_note_sharp, size: 30),
                onPressed: () async {
                  

                  HapticFeedback.lightImpact();
                  if (editMode) {
                    if (provider.userMode == UserMode.customMode) {
                      provider.addDrug(drug);
                    }

                    if (provider.isAdmin){
                  
           
                    if (await provider.checkIfDrugChanged(drug)) {

                      Map<String,String> possibleReviewerUIDs = await provider.getPossibleReviewerUIDs();
                      if (context.mounted) {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CommitDialog(
                            reviewers: possibleReviewerUIDs,
                            onCommit: (comment, selectedReviewerUIDs) {
                              final timestamp =
                                  DateTime.now().toIso8601String();

                              final changeMap = {
                                'comment': comment,
                                'timestamp': timestamp,
                                'user':
                                    FirebaseAuth.instance.currentUser!.email,
                                'reviewers': selectedReviewerUIDs,
                              };

                              if (changeMap.isNotEmpty) {
                                drug.changeNotes ??= []; // Initialize if null
                                drug.changeNotes!.add(changeMap);
                              }
                              if (selectedReviewerUIDs.isNotEmpty) {
                                drug.shouldReviewUIDs = selectedReviewerUIDs;
                                drug.hasReviewedUIDs = {};
                              }

                              // Save the drug
                              provider.addDrug(drug);
                              editModeProvider.toggleEditMode();

                           
                            },
                          );
                        },
                      );
                      }
                      return;
                    } 
                    }
            editModeProvider.toggleEditMode();
                  } 
                  
                  else {
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
