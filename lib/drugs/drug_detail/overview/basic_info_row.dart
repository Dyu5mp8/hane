import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/drug_detail/overview/concentration_column.dart';
import 'package:hane/ui_components/editable_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class BasicInfoRow extends StatelessWidget {
  const BasicInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<DrugListProvider>();
    return Consumer<Drug>(
      builder: (context, drug, child) {
        // Use only the Drug object here
        final concentrations = drug.concentrations;

        Widget buildSubtitle(BuildContext context, {preferGeneric = false}) {
          List<dynamic>? brandNames;
          brandNames = drug.preferredSecondaryNames(
            preferGeneric: preferGeneric,
          );
          // Check if brandNames is null or empty
          if (brandNames == null || brandNames.isEmpty) {
            return const SizedBox.shrink(); // No brand names, return empty widget
          }
          // Construct the rich text for brand names
          List<TextSpan> textSpans = [];

          if (preferGeneric == true) {
            // Apply the specified TextStyle to all names
            for (var name in brandNames) {
              textSpans.add(
                TextSpan(
                  text: name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );

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
              textSpans.add(
                TextSpan(
                  text: name,
                  style:
                      name == genericName
                          ? const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          )
                          : const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 11,
                          ),
                ),
              );

              // Add a comma separator if it's not the last item
              if (name != brandNames.last) {
                textSpans.add(const TextSpan(text: ', '));
              }
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
                        children:
                            drug.categories!
                                .map(
                                  (dynamic category) => Text(
                                    "#$category ",
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displaySmall,
                                  ),
                                )
                                .toList(),
                      ),
                    Consumer<EditModeProvider>(
                      builder: (context, editModeProvider, child) {
                        return EditableRow(
                          text: drug.preferredDisplayName(
                            preferGeneric: provider.preferGeneric,
                          ),
                          editDialog: EditNameDialog(drug: drug),
                          isEditMode: editModeProvider.editMode,
                          textStyle: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(fontSize: 22),
                        );
                      },
                    ),
                    if (drug.brandNames != null)
                      Flexible(
                        child: buildSubtitle(
                          context,
                          preferGeneric: provider.preferGeneric,
                        ),
                      ),
                  ],
                ),
              ),
              if (concentrations != null)
                Consumer<EditModeProvider>(
                  builder: (context, editModeProvider, child) {
                    return ConcentrationColumn(
                      concentrations: concentrations,
                      drug: drug,
                      isEditMode: editModeProvider.editMode,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
