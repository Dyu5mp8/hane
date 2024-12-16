import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/drug_list_view/drawers/read_feedback_view.dart';
import 'package:hane/drugs/ui_components/count_badge.dart';

class AdminMenuDrawer extends MenuDrawer {
  const AdminMenuDrawer({
    super.key,
  });

  @override
  List<Widget> buildUserSpecificTiles(BuildContext context) {

    var provider = Provider.of<DrugListProvider>(context, listen: false);
    return [
      ListTile(
        leading: const Icon(Icons.mark_chat_read),
        title: const Text('Markera alla meddelanden som lästa'),
        onTap: () {
          Navigator.pop(context);
          provider
              .markEveryMessageAsRead(
                  Provider.of<List<Drug>>(context, listen: false));
        },
      ),
      ListTile(
        leading: const Icon(Icons.check_circle_outline_sharp),
        title: const Text('Markera alla läkemedel som granskade'),
        onTap: () {
          Navigator.pop(context);
          provider
              .markEveryDrugAsReviewed(
                  Provider.of<List<Drug>>(context, listen: false));
        },
      ),
      ListTile(
       leading: CountBadge(futureCount: provider.getUserFeedbackCount() , child: const Icon(Icons.feedback_rounded)),
        title: const Text('Läs feedback'),
        onTap: () async {
          if (context.mounted) {
            Provider.of<DrugListProvider>(context, listen: false)
                .markFeedbackAsRead();
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
