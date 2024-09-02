import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/ui_components/sync_drugs_dialog.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/loginPage.dart';




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
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Provider.of<DrugListProvider>(context, listen: false).clearProvider();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Logga ut'),
            ),
          ],
        );
      },
    );
  }

  Set<String> masterUserDifference(Set<String> masterList, Set<String> userList) {
    print("Master list: $masterList");
    print("User list: $userList");
    print("Difference: ${masterList.difference(userList)}");
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
      future: Provider.of<DrugListProvider>(context).getDrugNamesFromMaster().timeout(Duration(seconds: 5)),
      builder: (context, snapshot) {
        return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Synka med stamlistan'),
              onTap: () {
                _onSyncPressed(context, masterUserDifference(snapshot.data as Set<String>, userDrugNames));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logga ut'),
              onTap: () {
                _onLogoutPressed(context);
              },
            ),
          ],
        ),
          );
      }
    );  
  }


  
}