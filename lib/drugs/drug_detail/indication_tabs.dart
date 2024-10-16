import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/models/drug.dart";




class IndicationTabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final editMode = context.watch<EditModeProvider>().editMode;
    Drug drug = context.watch<Drug>();
    final List<Indication> indications = drug.indications ?? [];
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor, // Set a solid, non-transparent background color
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (editMode)
            Container(
                width: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: IconButton(
                    onPressed: () {
                      Indication newIndication = Indication(isPediatric: false, name: '', notes: '');
                      
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditIndicationDialog(
                                    indication: newIndication,
                                    drug: drug,
                                    withDosages: true,
                                    isNewIndication: true,
                                  )));
                    },
                    icon: const Icon(Icons.add_circle_outline_sharp),
                    iconSize: 25,
                    color: Colors.black,
                    padding: EdgeInsets.zero)),
          Flexible(
       

            child: TabBar(
              
              unselectedLabelStyle:
                  const TextStyle(color: Color.fromARGB(255, 61, 61, 61)),
              labelColor: Colors.black,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromARGB(255, 255, 183, 148),
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
