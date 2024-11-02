import "package:flutter/material.dart";
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';
import 'package:hane/drugs/ui_components/custom_drawer_header.dart';
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

  void _onSyncPressed(BuildContext context, Set<String> difference) {
    showDialog(
      context: context,
      builder: (context) {
        return SyncDrugsDialog(difference: difference);
      },
    );
  }

  @override
  List<Widget> buildUserSpecificTiles(BuildContext context) {
    var user = Provider.of<DrugListProvider>(context, listen: false).user;
    return [
      ListTile(
        leading: const Icon(Icons.sync),
        title: const Text('Synkat läge'),
        trailing: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user)
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
              bool preferSynced =
                  snapshot.data?.data()?['preferSyncedMode'] ?? false;
              return Switch(
                value: preferSynced,
                onChanged: (value) async {
                  // Update the preference in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user)
                      .collection('preferences')
                      .doc('preferSyncedMode')
                      .set({'preferSyncedMode': value});

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InitializerWidget()),
                  );
                },
              );
            }
          },
        ),
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
              ...buildUserSpecificTiles(context),
              buildTutorialTile(context),
              DrugNameChoiceTile(),
              buildAboutTile(context),
              buildLogoutTile(context),
            ],
          ),
        );
      },
    );
  }

}
