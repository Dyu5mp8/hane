import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dialogs.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart';
import 'package:hane/drugs/drug_detail/indication_tab_view.dart';
import 'package:hane/drugs/drug_detail/indication_tabs.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';


class IndicationBox extends StatelessWidget {
  const IndicationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Drug>(
      builder: (context, drug, child) {
        if (drug.indications == null || drug.indications!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Icon(Icons.lightbulb_circle, color: Colors.grey, size: 50),
                Text(
                  "Inga indikationer ännu! Lägg till indikation eller gör andra ändringar...",
                ),
                SizedBox(height: 20),
                AddIndicationButton(),
              ],
            ),
          );
        }

        return Expanded(
          child: DefaultTabController(
            length: drug.indications!.length,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  IndicationTabs(),
                  IndicationTabView(),
                 
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddIndicationButton extends StatelessWidget {
  const AddIndicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    var drug = Provider.of<Drug>(context, listen: false);

    return ElevatedButton(

      onPressed: () {
        Provider.of<EditModeProvider>(context, listen: false).setEditMode(true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  EditIndicationDialog(withDosages: true, isNewIndication: true, indication: Indication(name : "", isPediatric: false), drug: drug)));
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Ny indikation'),
          SizedBox(width: 10),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}
