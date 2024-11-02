import "package:flutter/material.dart";
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:hane/drugs/drug_list_view/drawers/sync_drugs_dialog.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUserMenuDrawer extends MenuDrawer {
  final Set<String> userDrugNames;

  const CustomUserMenuDrawer({super.key, Set<String>? userDrugNames})
      : userDrugNames = userDrugNames ?? const {},
        super(userDrugNames: userDrugNames ?? const {});

  Set<String> masterUserDifference(
      Set<String> masterList, Set<String> userList) {
    return masterList.difference(userList);
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
              DrugNameChoiceTile(),
              SyncedModeTile(),
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
