import 'package:flutter/material.dart';

import 'package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart';
import 'package:hane/drugs/drug_detail/ui_components/scroll_indicator.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/user_behaviors/behaviors.dart';
import 'package:hane/drugs/services/user_behaviors/user_behavior.dart';
import 'package:flutter/services.dart';

class DosageList extends StatefulWidget {
  final List<Dosage> dosages;
  final bool editMode;
  final Drug drug;

  const DosageList({super.key, 
    required this.dosages,
    required this.editMode,
    required this.drug,
  });

  @override
  State<DosageList> createState() => _DosageListState();
}

class _DosageListState extends State<DosageList> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ReorderableListView.builder(
        scrollController: _scrollController,
        buildDefaultDragHandles: false,
        onReorder: (int oldIndex, int newIndex) {
          // Adjust newIndex if needed to ensure proper insertion
          if (newIndex > oldIndex) {
            newIndex--;
          }
          final movedDosage = widget.dosages.removeAt(oldIndex);
          widget.dosages.insert(newIndex, movedDosage);
          HapticFeedback.mediumImpact();
      
          // Optionally update the parent Drug if needed, e.g.,
          widget.drug.updateDrug();
        },
        padding: const EdgeInsets.all(1),
        itemCount: widget.dosages.length,
        itemBuilder: (context, index) {
          return Container(
            key: ValueKey(
                widget.dosages[index].hashCode), // Unique key for the entire row
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceBright,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: const Color.fromARGB(255, 220, 220, 220),
              
                width: 0.5,
              ),
            ),
            margin: const EdgeInsets.symmetric(
                vertical: 4), // Optional margin between items
            child: Row(
              children: [
                if (widget.editMode)
                  ReorderableDragStartListener(
                    index: index,
                    child: const SizedBox(
                        width: 40,
                        child: Icon(Icons.drag_handle, color: Colors.grey)),
                  ),
                Expanded(
                  child: DosageSnippet(
                    key: ValueKey(
                        widget.dosages[index].hashCode), // Use DosageSnippet key
                    editMode: widget.editMode,
                    onDosageDeleted: () {
                      setState(() {
                        widget.dosages.removeAt(index);
                        widget.drug.updateDrug();
                      });
                 
                    },
                    availableConcentrations: widget.drug.concentrations,
                    dosage: widget.dosages[index],
                    onDosageUpdated: (updatedDosage) {
                      setState(() {
                        widget.dosages[index] = updatedDosage;
                        widget.drug.updateDrug();
      
                      });
                   
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      Positioned(
                bottom: 15,
                right: 15,
                child: ScrollIndicator(scrollController: _scrollController)),
      ]
    );

    // Floating action button for editing the indication
  }
}
