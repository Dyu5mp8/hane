import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/dosage_view_handler.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';

import 'package:hane/ui_components/dosage_snippet.dart';
import 'package:hane/ui_components/scroll_indicator.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/user_behaviors/behaviors.dart';
import 'package:hane/drugs/services/user_behaviors/user_behavior.dart';
import 'package:flutter/services.dart';

class DosageList extends StatefulWidget {
  final List<Dosage> dosages;
  final bool editMode;
  final String? instruction;

  const DosageList({
    super.key,
    required this.dosages,
    required this.editMode,

    this.instruction,
  });

  @override
  State<DosageList> createState() => _DosageListState();
}

class _DosageListState extends State<DosageList> {
  final _scrollController = ScrollController();
  @override
  String? instruction;

  @override
  void initState() {
    super.initState();
    instruction = widget.instruction;
  }

  @override
  Widget build(BuildContext context) {
    final drug = Provider.of<Drug>(context, listen: false);

    return Stack(
      children: [
        ReorderableListView.builder(
          header:
              (instruction != null && instruction!.isNotEmpty)
                  ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),

                    child: Text(
                      "Kommentar: ${instruction!}",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : null,
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
            drug.updateDrug();
          },
          padding: const EdgeInsets.all(1),
          itemCount: widget.dosages.length,
          itemBuilder: (context, index) {
            return Container(
              key: ValueKey(
                widget.dosages[index].hashCode,
              ), // Unique key for the entire row
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 0.1,
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
              ), // Optional margin between items
              child: Row(
                children: [
                  if (widget.editMode)
                    ReorderableDragStartListener(
                      index: index,
                      child: const SizedBox(
                        width: 40,
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                  Expanded(
                    child: ChangeNotifierProvider(
                      create:
                          (_) => DosageViewHandler(
                            dosage: widget.dosages[index],
                            availableConcentrations:
                                drug.concentrations, // initial concentrations
                            onDosageDeleted: () {
                              setState(() {
                                widget.dosages.removeAt(index);
                                drug.updateDrug();
                              });
                            },
                            onDosageUpdated: (updatedDosage) {
                              setState(() {
                                widget.dosages[index] = updatedDosage;
                                drug.updateDrug();
                              });
                            },
                          ),
                      child: Consumer<Drug>(
                        builder: (context, updatedDrug, child) {
                          // Update availableConcentrations in the DosageViewHandler whenever the drug changes
                          Provider.of<DosageViewHandler>(
                                context,
                                listen: false,
                              ).availableConcentrations =
                              updatedDrug.concentrations;
                          return DosageSnippet(
                            key: ValueKey(widget.dosages[index].hashCode),
                            editMode: widget.editMode,
                          );
                        },
                      ),
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
          child: ScrollIndicator(scrollController: _scrollController),
        ),
      ],
    );

    // Floating action button for editing the indication
  }
}
