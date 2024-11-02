import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SyncedUserMenuDrawer extends MenuDrawer {
  const SyncedUserMenuDrawer({super.key});


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
              SyncedModeTile(),
              DrugNameChoiceTile(),
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
