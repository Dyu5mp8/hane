import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart";
import "package:hane/drugs/drug_detail/edit_mode_provider.dart";
import "package:hane/drugs/models/drug.dart";

class AddIndicationButton extends StatelessWidget {
  const AddIndicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    var drug = Provider.of<Drug>(context, listen: true);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(194, 221, 248, 1),
      
   
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),

      onPressed: () {
        Provider.of<EditModeProvider>(context, listen: false).setEditMode(true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditIndicationDialog(
                    withDosages: true,
                    isNewIndication: true,
                    indication: Indication(isPediatric: false, name: '', notes: ''),
                    drug: drug,
             ) ));
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
