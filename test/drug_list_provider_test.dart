import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hane/drugs/drug_list_view/drug_list_view.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var firestore = FirebaseFirestore.instance;

  firestore.settings = const Settings(persistenceEnabled: true, 
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  group('dose', () {
    test("create", () {

      DrugListProvider test_provider = DrugListProvider();

      test_provider.isAdmin = false;
      test_provider.masterUID = "master";
      test_provider.user = "BOH4xmTmM9UFacvLRsDSnDN5mDB3";

      Drug newDrug = Drug(name: "test", changedByUser: false, brandNames: [], categories: [], concentrations: [], contraindication: "", indications: [], notes: "", lastUpdated: null);

      test_provider.addDrug(newDrug);
      // 
    });

    test("should convert", () {
      // 
    });
  });
}