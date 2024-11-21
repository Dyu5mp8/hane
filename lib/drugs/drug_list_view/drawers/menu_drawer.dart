import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_list_view/drawers/drawer_header.dart';
import 'package:hane/login/user_status.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/login_page.dart';
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
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }
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
              const DrugNameChoiceTile(),

              buildTutorialTile(context), // Added tutorial tile
              buildAboutTile(context), // Added about tile
              buildLogoutTile(context), // Common logout tile
            ],
          ),
        );
      },
    );
  }

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
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      },
    );
  }

  // Updated return type to Widget
  Widget buildAboutTile(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;
          return AboutListTile(
            icon: const Icon(Icons.info),
            applicationName: packageInfo.appName,
            applicationVersion: packageInfo.version,
            applicationLegalese: '${DateTime.now().year}',
            aboutBoxChildren: const [
              SizedBox(height: 5),
              Text(
                  'Denna app är avsedd för medicinska yrkesverksamma. Informationen som '
                  'presenteras är endast för utbildningsändamål och bör inte användas som '
                  'ersättning för en klinisk bedömning. '
                  'Skaparen av denna plattform tar inget '
                  'ansvar för användningen av informationen i denna app.'),
              SizedBox(height: 10),
              Text(
                'Om du har några frågor eller upptäcker något fel med appen, maila vichy576@gmail.com',
              ),
            ],
            child: const Text('Om applikationen'),
          );
        } else {
          // While the package info is loading, show a placeholder
          return AboutListTile(
            icon: const Icon(Icons.info),
            applicationName: 'AnestesiH',
            applicationLegalese: '${DateTime.now().year}',
            aboutBoxChildren: const [
              SizedBox(height: 5),
              Text(
                  'Denna app är avsedd för medicinska yrkesverksamma. Informationen som '
                  'presenteras är endast för utbildningsändamål och bör inte användas som '
                  'ersättning för en klinisk bedömning. '
                  'Skaparen av denna plattform tar inget '
                  'ansvar för användningen av informationen i denna app.'),
              SizedBox(height: 10),
              Text(
                'Om du har några frågor eller upptäcker något fel med appen, maila vichy576@gmail.com',
              ),
            ],
            child: const Text('Om applikationen'),
          );
        }
      },
    );
  }
}

class DrugNameChoiceTile extends StatefulWidget {
  const DrugNameChoiceTile({super.key});

  @override
  State<DrugNameChoiceTile> createState() => _DrugNameChoiceTileState();
}

class _DrugNameChoiceTileState extends State<DrugNameChoiceTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.text_format),
      title: const Text('Visa alltid generika först'),
      trailing: Switch(
        value: Provider.of<DrugListProvider>(context).preferGeneric,
        onChanged: (value) {
          Provider.of<DrugListProvider>(context, listen: false)
              .setPreferGeneric(value);
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value
                    ? 'Ändrat: Generiska namn visas först'
                    : 'Ändrat: Generiska namn visas under i fetstil'),
              ),
            );
          });
        },
      ),
    );
  }
}

class SyncedModeTile extends StatefulWidget {
  const SyncedModeTile({super.key});

  @override
  State<SyncedModeTile> createState() => _SyncedModeTileState();
}

class _SyncedModeTileState extends State<SyncedModeTile> {
  @override
  Widget build(BuildContext context) {
    final drugListProvider = Provider.of<DrugListProvider>(context);

    return ListTile(
      leading: const Icon(Bootstrap.arrow_repeat),
      title: const Text('Synkat läge'),
      trailing: Switch(
        value: drugListProvider.isSyncedMode,
        onChanged: (value) {
          if (value) {
            drugListProvider.userMode = UserMode.syncedMode;  
          } else {
            drugListProvider.userMode = UserMode.customMode;
          }

          // Show a SnackBar for feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value
                  ? 'Ändrat: Synkat läge aktiverat'
                  : 'Ändrat: Eget läge aktiverat'),
            ),
          );
        },
      ),
    );
  }
}
