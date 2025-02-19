import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/app_theme.dart';

class PreferenceSelectionScreen extends StatelessWidget {
  final String user;

  const PreferenceSelectionScreen({super.key, required this.user});

  Future<void> _setPreference(BuildContext context, bool preferSynced) async {
    // Store preference in SharedPreferences
    final SharedPreferences localPrefs = await SharedPreferences.getInstance();
    await localPrefs.setString('preferSyncedMode', preferSynced.toString());

    // Store preference in Firestore
    final prefs = FirebaseFirestore.instance.collection('users').doc(user);

    await prefs.set({
      'preferSyncedMode': preferSynced,
    }, SetOptions(merge: true));

    // Re-initialize the app after setting preference
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitializerWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('Välj läge')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildModeCard(
                context,
                title: 'Synkat läge (rekommenderat)',
                description:
                    'I detta läge synkas listan med stamlistan som är under kontinuerlig revision och uppdatering. Du kan inte ändra läkemedlena från stamlistan.',
                buttonText: 'Använd Synkat läge',
                onPressed: () => _setPreference(context, true),
                icon: Icons.sync, // Adding an icon
                cardColor: Colors.blue[50]!,
                buttonColor: const Color.fromARGB(255, 184, 217, 244),
              ),
              const SizedBox(height: 20),
              _buildModeCard(
                context,
                title: 'Användarskapat läge',
                description:
                    'I detta läge kan du redigera listan fritt och lägga till och ta bort läkemedel, och har mer kontroll över vad som visas under varje läkemedel. ',
                buttonText: 'Använd användarskapat läge',
                onPressed: () => _setPreference(context, false),
                icon: Icons.settings,
                cardColor: Colors.orange[50]!,
                buttonColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    required IconData icon,
    required Color cardColor,
    required Color buttonColor,
  }) {
    ThemeData theme = appTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ), // Increased padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Icon(icon, size: 40, color: theme.primaryColor), // Add icon
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      buttonColor, // Use buttonColor for better contrast
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(buttonText, style: theme.textTheme.headlineMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
