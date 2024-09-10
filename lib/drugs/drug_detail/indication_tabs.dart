import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/drugs/models/indication.dart";


class IndicationTabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final editMode = context.watch<EditModeProvider>().editMode;
    final List<Indication> indications = context.watch<Drug>().indications ?? [];
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
                    onPressed: () {},
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
