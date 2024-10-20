import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/models/drug.dart";
import "package:reorderable_tabbar/reorderable_tabbar.dart";

class IndicationTabs extends StatefulWidget {
  const IndicationTabs({super.key});

  @override
  State<IndicationTabs> createState() => _IndicationTabsState();
}

class _IndicationTabsState extends State<IndicationTabs> {
  @override
  Widget build(BuildContext context) {
    final editMode = context.watch<EditModeProvider>().editMode;
    Drug drug = context.watch<Drug>();
    final List<Indication> indications = drug.indications ?? [];

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .canvasColor, // Set a solid, non-transparent background color
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (editMode)
            Container(
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: IconButton(
                onPressed: () {
                  Indication newIndication = Indication(
                    isPediatric: false,
                    name: '',
                    notes: '',
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditIndicationDialog(
                        indication: newIndication,
                        drug: drug,
                        withDosages: true,
                        isNewIndication: true,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_sharp),
                iconSize: 25,
                color: Colors.black,
                padding: EdgeInsets.zero,
              ),
            ),
          Flexible(
            child: editMode
                ? ReorderableTabBar(
                    buildDefaultDragHandles: false,
                    unselectedLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 61, 61, 61),
                    ),
                    labelColor: Colors.black,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabBorderRadius: BorderRadius.circular(5),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    tabs: indications
                        .map((indication) => Tab(
                                child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Transform.scale(
                                  scaleX: 0.6,
                                  origin: const Offset(-10, 0),
                                    child: const Icon(
                                  Icons.drag_handle,
                                  size: 30,
                                )),
                              ),
                              Text(indication.name)
                            ])))
                        .toList(),
                    onReorder: (int oldIndex, int newIndex) {
                      // Fix reordering logic
                      if (oldIndex != newIndex) {
                        setState(() {
                          Indication temp = indications.removeAt(oldIndex);
                          indications.insert(newIndex, temp);

                          // Update the indications list in the drug object
                          drug.indications = indications;
                          drug.updateDrug(); // Update the drug with the reordered list
                        });
                      }
                    },
                  )
                : TabBar(
                    tabAlignment: TabAlignment.start,
                    unselectedLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 61, 61, 61),
                    ),
                    labelColor: Colors.black,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 255, 183, 148),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    tabs: indications
                        .map((indication) => Tab(text: indication.name))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
