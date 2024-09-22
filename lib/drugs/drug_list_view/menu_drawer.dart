import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/ui_components/custom_drawer_header.dart';
import 'package:hane/drugs/drug_list_view/sync_drugs_dialog.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/loginPage.dart';


abstract class MenuDrawer extends StatelessWidget {
  final Set<String>? userDrugNames;
  const MenuDrawer({super.key, this.userDrugNames });


  // Common logout method for all users
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

  // Base drawer layout
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
              buildLogoutTile(context), // Common logout tile
              ...buildUserSpecificTiles(context), // User-specific tiles in subclasses
            ],
          ),
        );
      },
    );
  }

  // Common logout tile for all users
  ListTile buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logga ut'),
      onTap: () {
        _onLogoutPressed(context);
      },
    );
  }
  // Abstract method to be implemented in subclasses
  List<Widget> buildUserSpecificTiles(BuildContext context);
}