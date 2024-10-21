import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/ui_components/custom_drawer_header.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/onboarding/onboarding_screen.dart';

abstract class MenuDrawer extends StatelessWidget {
  final Set<String>? userDrugNames;
  const MenuDrawer({super.key, this.userDrugNames});

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
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                Provider.of<DrugListProvider>(context, listen: false)
                    .clearProvider();
                await FirebaseAuth.instance.signOut();
                // Clear the navigation stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
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
        

              ...buildUserSpecificTiles(context),
              buildLogoutTile(
                  context), // Common logout tile// User-specific tiles in subclasses
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

  ListTile buildTutorialTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.help),
      title: const Text('Hur funkar det?'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      },
    );
  }

  // Abstract method to be implemented in subclasses
  List<Widget> buildUserSpecificTiles(BuildContext context);
}
