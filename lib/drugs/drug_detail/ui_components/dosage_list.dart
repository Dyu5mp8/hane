import 'package:flutter/material.dart';

import 'package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/user_behaviors/behaviors.dart';
import 'package:hane/drugs/services/user_behaviors/user_behavior.dart';
import 'package:flutter/services.dart';

class DosageList extends StatelessWidget {
  final List<Dosage> dosages;
  final bool editMode;
  final Drug drug;

  DosageList({
    required this.dosages,
    required this.editMode,
    required this.drug,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      onReorder: (int oldIndex, int newIndex) {
        // Adjust newIndex if needed to ensure proper insertion
        if (newIndex > oldIndex) {
          newIndex--;
        }
        final movedDosage = dosages.removeAt(oldIndex);
        dosages.insert(newIndex, movedDosage);
        HapticFeedback.mediumImpact();

        // Optionally update the parent Drug if needed, e.g.,
        drug.updateDrug();
      },
      padding: const EdgeInsets.all(1),
      itemCount: dosages.length,
      itemBuilder: (context, index) {
        return Container(
          key: ValueKey(
              dosages[index].hashCode), // Unique key for the entire row
          decoration: BoxDecoration(
            color: Colors.white, // Your background color
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Color.fromARGB(255, 220, 220, 220),
              width: 0.5,
            ),
          ),
          margin: const EdgeInsets.symmetric(
              vertical: 4), // Optional margin between items
          child: Row(
            children: [
              if (editMode)
                ReorderableDragStartListener(
                  index: index,
                  child: SizedBox(
                      width: 40,
                      child: const Icon(Icons.drag_handle, color: Colors.grey)),
                ),
              Expanded(
                child: DosageSnippet(
                  key: ValueKey(
                      dosages[index].hashCode), // Use DosageSnippet key
                  editMode: editMode,
                  onDosageDeleted: () {
                    dosages.removeAt(index);
                    drug.updateDrug();
                  },
                  availableConcentrations: drug.concentrations,
                  dosage: dosages[index],
                  onDosageUpdated: (updatedDosage) {
                    dosages[index] = updatedDosage;
                    drug.updateDrug();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    // Floating action button for editing the indication
  }
}
