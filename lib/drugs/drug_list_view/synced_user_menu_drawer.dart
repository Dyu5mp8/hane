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







class SyncedUserMenuDrawer extends MenuDrawer {

  const SyncedUserMenuDrawer({super.key});

  @override
  List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [
    ListTile(
  leading: const Icon(Icons.sync),
  title: const Text('Synkat läge'),
  trailing: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('preferences')
        .doc('preferSyncedMode')
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      } else if (snapshot.hasError) {
        return const Icon(Icons.error, color: Colors.red);
      } else {
        bool preferSynced = snapshot.data?.data()?['preferSyncedMode'] ?? false;
        return Switch(
          value: preferSynced,
          onChanged: (value) async {
            // Update the preference in Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('preferences')
                .doc('preferSyncedMode')
                .set({'preferSyncedMode': value});

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InitializerWidget()),
            );
          },
        );
      }
    },
  ),
),
    ];
  }


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