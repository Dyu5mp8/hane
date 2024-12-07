import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/drug_list_view/drawers/user_feedback.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/drug_list_view/drawers/read_feedback_view.dart';


class AdminMenuDrawer extends MenuDrawer {
  const AdminMenuDrawer({
    super.key,
  });



  @override
  List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.mark_chat_read),
        title: const Text('Markera alla meddelanden som lästa'),
        onTap: () {
          Navigator.pop(context);
          Provider.of<DrugListProvider>(context, listen: false)
              .markEveryMessageAsRead(
                  Provider.of<List<Drug>>(context, listen: false));
        },
      ),
       ListTile(
        leading: const Icon(Icons.check_circle_outline_sharp),
        title: const Text('Markera alla läkemedel som granskade'),
        onTap: () {
          Navigator.pop(context);
          Provider.of<DrugListProvider>(context, listen: false)
              .markEveryDrugAsReviewed(
                  Provider.of<List<Drug>>(context, listen: false));
        },

      ),

      ListTile(
        leading: const Icon(Icons.feedback),
        title: const Text('Läs feedback'),
        onTap: () async {
          if (context.mounted) {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadFeedbackView(), 

                
              ),
          );
          }       
        },
      ),
    ];
  }
}