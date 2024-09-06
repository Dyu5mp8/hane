import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview_box.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';

class DrugDetailView extends StatefulWidget {
  final Drug drug;

  const DrugDetailView({super.key, required this.drug});

  @override
  State<DrugDetailView> createState() => _DrugDetailViewState();
}

class _DrugDetailViewState extends State<DrugDetailView> {
  bool editMode = false;
  @override
  Widget build(BuildContext context) {

     return ChangeNotifierProvider<Drug>.value(
      value: widget.drug,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.drug.name ?? 'Drug Details'),
          actions: [

            if (editMode) IconButton(
              icon: Icon(Icons.delete, color: Color.fromARGB(255, 122, 0, 0)),
              onPressed: () {
                Provider.of<DrugListProvider>(context, listen: false)
                    .deleteDrug(widget.drug); 
                Navigator.pop(context);
              },
            )
            
             ,IconButton(
            icon: Icon(editMode ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                editMode = !editMode;
              });
            },
          )],
        ),
        body: Column(
          children: <Widget>[
            OverviewBox(editMode: editMode),
            

            IndicationBox()
          ],
        ),
      ),
    );
  }
}