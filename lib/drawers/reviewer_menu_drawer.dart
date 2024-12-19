import 'package:flutter/material.dart';
import 'package:hane/drawers/menu_drawer.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class ReviewerMenuDrawer extends MenuDrawer {

  const ReviewerMenuDrawer({super.key, 
    
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
    ];
  }
}
