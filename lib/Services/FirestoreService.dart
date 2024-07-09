import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _singleton = FirestoreService._internal();
  late final FirebaseFirestore firestore;

  factory FirestoreService() {
    return _singleton;
  }

  FirestoreService._internal() {
    firestore = FirebaseFirestore.instance;
    try {
      firestore.settings = const Settings(persistenceEnabled: true);
    } catch (e) {
      print("An error occurred while setting Firestore persistence: $e");
    }
  }

  FirebaseFirestore get db => firestore;
}