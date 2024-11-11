import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class AdminMenuDrawer extends MenuDrawer {
  const AdminMenuDrawer({
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
