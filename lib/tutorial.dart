import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


mixin Tutorial {



  void showTutorialScreenIfNew(String tutorial, Widget tutorialScreen, BuildContext context) async {
    var db = FirebaseFirestore.instance;
    bool? seenTutorial = await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data()?[tutorial]);

    if (context.mounted && (seenTutorial == null || !seenTutorial)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => tutorialScreen),
      );
      db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        tutorial: true,
      });
    }
}
}