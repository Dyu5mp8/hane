import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/ui_components/custom_drawer_header.dart';
import 'package:hane/drugs/drug_list_view/sync_drugs_dialog.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';






class MenuDrawer extends StatelessWidget {
  final Set<String> userDrugNames;
  const MenuDrawer({super.key, this.userDrugNames = const {}});

    void _onLogoutPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vill du logga ut?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<DrugListProvider>(context, listen: false).clearProvider();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  
                );
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Logga ut'),
            ),
          ],
        );
      },
    );
  }

  

  Set<String> masterUserDifference(Set<String> masterList, Set<String> userList) {
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
            ListTile(
              leading: Badge(
                child: const Icon(Icons.settings),
                label: snapshot.connectionState == ConnectionState.waiting
                    ? const Text('...')
                    : snapshot.hasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : Text(masterUserDifference(snapshot.data as Set<String>, userDrugNames).length.toString()),
              ),
              title: const Text('Synka med stamlistan'),
              onTap: () {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasError) {
                  _onSyncPressed(
                    context,
                    masterUserDifference(snapshot.data as Set<String>, userDrugNames),
                  );
                } else if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: const Text('Failed to load data')),
                  );
                }
              },
            ),
            ListTile(
  leading: const Icon(Icons.sync),
  title: const Text('Synced Mode'),
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logga ut'),
              onTap: () {
                _onLogoutPressed(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
}