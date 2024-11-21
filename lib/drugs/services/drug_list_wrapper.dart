import "package:flutter/material.dart";
import "package:hane/drugs/drug_list_view/drug_list_view.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/drugs/services/drug_list_provider.dart";

class DrugListWrapper extends StatelessWidget {
  const DrugListWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Drug>?>.value(
      value:
          Provider.of<DrugListProvider>(context, listen: true).getDrugsStream(),
      initialData: null, // Change initial data to null to indicate loading
      catchError: (_, error) => [],
      child: const DrugListView(),
    );
  }
}
