
import 'package:hane/drugs/models/drug.dart';

export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:hane/drugs/models/drug.dart';
export 'package:hane/drugs/services/user_behaviors/admin_user_behavior.dart';
export 'package:hane/drugs/services/user_behaviors/custom_user_behavior.dart';
export 'package:hane/drugs/services/user_behaviors/synced_user_behavior.dart';


abstract class UserBehavior {
  String masterUID;
  String? user;
  Set categories = {};
  UserBehavior({required this.masterUID, this.user});

  Future<void> addDrug(Drug drug);
  Future<void> deleteDrug(Drug drug);
  Stream<List<Drug>> getDrugsStream();
}
