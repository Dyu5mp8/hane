
import "package:flutter/material.dart";
import "package:hane/drugs/drug_list_view/drug_list_view.dart";
import "package:hane/drugs/models/drug.dart";
import "package:provider/provider.dart";
import "package:hane/drugs/services/drug_list_provider.dart";


class DrugListWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Drug>>.value(
      value: Provider.of<DrugListProvider>(context, listen: false).getDrugsStream(),
      initialData: [],
      catchError: (_, error) => [],
      child: DrugListView(),
    );
  }
}