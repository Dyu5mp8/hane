import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/expanded_info/expanded_dialog.dart';
import 'package:hane/drugs/drug_detail/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/user_status.dart';
import 'package:hane/drugs/drug_detail/ui_components/scroll_indicator.dart';
import 'package:icons_plus/icons_plus.dart';

class OverviewBox extends StatefulWidget {
  const OverviewBox({super.key});

  @override
  _OverviewBoxState createState() => _OverviewBoxState();
}

class _OverviewBoxState extends State<OverviewBox> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Dispose of the scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DrugListProvider provider =
        Provider.of<DrugListProvider>(context, listen: false);
    Drug drug = Provider.of<Drug>(context, listen: false);
    bool shouldShowUserNotes = (provider.userMode == UserMode.syncedMode &&
        drug.changedByUser == false);

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  BasicInfoRow(),
                  NoteRow(),
                  const Divider(indent: 10, endIndent: 10, thickness: 1),
                  ContraindicationRow(),
                  if (shouldShowUserNotes)
                    const Divider(indent: 10, endIndent: 10, thickness: 1),
                  if (shouldShowUserNotes) UserNoteRow(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Include the ScrollIndicator widget
            Positioned(
                bottom: 15,
                right: 15,
                child: ScrollIndicator(scrollController: _scrollController)),
          ],
        ),
      ),
    );
  }
}

class BasicInfoRow extends StatelessWidget {
  const BasicInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider =context.read<DrugListProvider>();
    return Consumer<Drug>(
      builder: (context, drug, child) {
        // Use only the Drug object here
        final concentrations = drug.concentrations;

        Widget _buildSubtitle(BuildContext context, {preferGeneric = false}) {
  List<dynamic>? brandNames;
  brandNames = drug.preferredSecondaryNames(preferGeneric: preferGeneric);
  // Check if brandNames is null or empty
  if (brandNames == null || brandNames!.isEmpty) {
    return const SizedBox.shrink(); // No brand names, return empty widget
  }
  // Construct the rich text for brand names
  List<TextSpan> textSpans = [];

  if (preferGeneric == true ) {
    // Apply the specified TextStyle to all names
    for (var name in brandNames) {
      textSpans.add(TextSpan(
        text: name,
        style: const TextStyle(
        
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      ));

      // Add a comma separator if it's not the last item
      if (name != brandNames.last) {
        textSpans.add(const TextSpan(text: ', '));
      }
    }
  } else {
    // Use the existing logic when preferGeneric is false or null
    String? genericName = drug.genericName; 
    // Assuming `genericName` is in Drug class
    for (var name in brandNames) {
      textSpans.add(TextSpan(
        text: name,
        style: name == genericName
            ? const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              )
            : const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
      ));

      // Add a comma separator if it's not the last item
      if (name != brandNames.last) {
        textSpans.add(const TextSpan(text: ', '));
      }
    }
  }

  return Text.rich(
    TextSpan(
      children: textSpans,
    ),
  );
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
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ))
                            .toList(),
                      ),
                    Consumer<EditModeProvider>(
                      builder: (context, editModeProvider, child) {
                        return EditableRow(
                            text: drug.preferredDisplayName(
                                preferGeneric: provider.preferGeneric),
                            editDialog: EditNameDialog(drug: drug),
                            isEditMode: editModeProvider.editMode,
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge);
                      },
                    ),
                    if (drug.brandNames != null)
                      Flexible(
                        child: _buildSubtitle(context, preferGeneric : provider.preferGeneric),
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
                                text: "Styrkor",
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall,
                                editDialog:
                                    EditConcentrationsDialog(drug: drug),
                                isEditMode: editModeProvider.editMode,
                              );
                            },
                          ),
                          ...drug
                              .getConcentrationsAsString()!
                              .map((conc) => Text(conc))
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
              label: Icon(Icons.info, size: 17, color: Theme.of(context).colorScheme.primary),
              backgroundColor: Colors.transparent,
              isLabelVisible: (drug.expandedNotes?.isNotEmpty ?? false),
              child: const Icon(Icons.notes,)),
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
      child: InkWell(
        onTap: () {
         if (drug.expandedContraindication?.isNotEmpty ?? false)
          showDialog(
            context: context,
            builder: (context) => ExpandedDialog(
              text: drug.expandedContraindication!,
            ),
          );
        },
        child: Row(
          
          children: [
            Badge(
              child: const Icon(FontAwesome.circle_exclamation_solid, color: Color.fromARGB(255, 122, 0, 0)),
               label: Icon(Icons.info, size: 17, color: Theme.of(context).colorScheme.primary),
              backgroundColor: Colors.transparent,
           
              isLabelVisible: ((drug.expandedContraindication?.isNotEmpty ?? false) && !editMode),
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
                  builder: (context) => EditNotesDialog(
                      drug: drug,
                      isUserNote: true,
                      onUserNotesSaved: () {
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
