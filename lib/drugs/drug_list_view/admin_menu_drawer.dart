import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_list_view/menu_drawer.dart';
import 'package:hane/drugs/ui_components/custom_drawer_header.dart';
import 'package:hane/drugs/drug_list_view/sync_drugs_dialog.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';







class AdminMenuDrawer extends MenuDrawer {
  const AdminMenuDrawer({Key? key,}) : super(key: key);

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