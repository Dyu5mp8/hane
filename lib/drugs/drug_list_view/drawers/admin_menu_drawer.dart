import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/models/drug.dart';
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
  leading: Badge(
    label: Consumer<DrugListProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<AggregateQuerySnapshot>(
          future: provider.userFeedbackQuery.count().get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Waiting for data, show nothing
              return const SizedBox.shrink();
            }
            
            if (snapshot.hasError || !snapshot.hasData) {
              // Error or no data, show nothing
              return const SizedBox.shrink();
            }

            final count = snapshot.data!.count;
            if (count == 0) {
              // No documents, show nothing
              return const SizedBox.shrink();
            }

            // Successfully got a count, show it
            return Text(count.toString());
          },
        );
      },
    ),
    child: const Icon(Icons.feedback),
  ),
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
