import 'package:flutter/services.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview_box.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';

class DrugDetailView extends StatefulWidget {
  final Drug drug;
  final bool newDrug;

  const DrugDetailView({super.key, required this.drug, this.newDrug = false});

  @override
  State<DrugDetailView> createState() => _DrugDetailViewState();
}

class _DrugDetailViewState extends State<DrugDetailView> {
  bool editMode = false;

  @override
  void initState() {
    super.initState();

    // Example to show a dialog right after the widget has been built
    Future.delayed(Duration(milliseconds: 300), () {
      if (widget.newDrug) {
        _showNewDrugDialog();
      }
    });
  }

  void _showNewDrugDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNameDialog(drug: widget.drug);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Drug>.value(
      value: widget.drug,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: editMode ? false : true,
          title: Text(widget.drug.name ?? 'Drug Details'),
          centerTitle: true,
          actions: [
            if (editMode)
              IconButton(
                icon: Icon(Icons.delete, color: Color.fromARGB(255, 122, 0, 0)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Radera läkemedel'),
                        content: Text(
                            'Är du säker på att du vill radera detta läkemedel?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Avbryt'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<DrugListProvider>(context,
                                      listen: false)
                                  .deleteDrug(widget.drug);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Radera'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            IconButton(
              icon: editMode
                  ? Text(
                      "Spara",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    )
                  : Icon(Icons.edit_note_sharp, size: 30),
              onPressed: () {
                HapticFeedback.lightImpact();
                if (editMode) {
                  Provider.of<DrugListProvider>(context, listen: false)
                      .addDrug(widget.drug);
                }
                setState(() {
                  editMode = !editMode;
                });
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            OverviewBox(editMode: editMode),
            IndicationBox(editMode: editMode)
          ],
        ),
      ),
    );
  }
}
