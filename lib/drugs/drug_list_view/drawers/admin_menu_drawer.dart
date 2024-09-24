import "package:flutter/material.dart";

import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/ui_components/custom_drawer_header.dart';

import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class AdminMenuDrawer extends MenuDrawer {
  const AdminMenuDrawer({
    super.key,
  });

  @override
  List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [];
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
              ...buildUserSpecificTiles(context),
              buildLogoutTile(context),
            ],
          ),
        );
      },
    );
  }
}
