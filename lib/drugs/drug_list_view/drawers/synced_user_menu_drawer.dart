import "package:flutter/material.dart";
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class SyncedUserMenuDrawer extends MenuDrawer {
  const SyncedUserMenuDrawer({super.key});

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
              const SyncedModeTile(),
              const DrugNameChoiceTile(),
              buildTutorialTile(context),
              buildAboutTile(context),
              buildLogoutTile(context),
            ],
          ),
        );
      },
    );
  }
}
