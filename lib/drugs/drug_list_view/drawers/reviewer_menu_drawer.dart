import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class ReviewerMenuDrawer extends MenuDrawer {
  const ReviewerMenuDrawer({
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DrugListProvider>(context)
          .getDrugNamesFromMaster()
          .timeout(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const CustomDrawerHeader(),
              const DrugNameChoiceTile(),
              ...buildUserSpecificTiles(context),
              
              buildLogoutTile(context),
            ],
          ),
        );
      },
    );
  }
}