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

  Future<void> addDrug(Drug drug) {
    throw UnimplementedError('addDrug not implemented');
  }

  Future<void> deleteDrug(Drug drug) {
    throw UnimplementedError('deleteDrug not implemented');
  }

  Stream<List<Drug>> getDrugsStream({bool sortByGeneric = false});

   Future<void> addUserNotes(String id, String notes) async {
  throw UnimplementedError('addUserNotes not implemented');
 }


}
