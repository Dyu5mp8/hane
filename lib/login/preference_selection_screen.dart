import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferenceSelectionScreen extends StatelessWidget {
  final String user;
  
  
  const PreferenceSelectionScreen({super.key, required this.user});

Future<void> _setPreference(BuildContext context, bool preferSynced) async {
  // Store preference in SharedPreferences
  final SharedPreferences localPrefs = await SharedPreferences.getInstance();
  await localPrefs.setString('preferSyncedMode', preferSynced.toString());

  // Store preference in Firestore
  final prefs = FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .collection('preferences')
      .doc("preferSyncedMode");

  await prefs.set({
    'preferSyncedMode': preferSynced,
  }, SetOptions(merge: true));

  // Re-initialize the app after setting preference
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const InitializerWidget()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Preference')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Do you prefer to use synced mode?'),
            ElevatedButton(
              onPressed: () => _setPreference(context, true),
              child: const Text('Yes, use synced mode'),
            ),
            ElevatedButton(
              onPressed: () => _setPreference(context, false),
              child: const Text('No, use custom mode'),
            ),
          ],
        ),
      ),
    );
  }
}