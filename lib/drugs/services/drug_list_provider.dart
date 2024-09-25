import 'dart:async';
import 'package:hane/drugs/services/user_behaviors/behaviors.dart';

import 'package:flutter/material.dart';

import 'package:hane/login/user_status.dart';

class DrugListProvider with ChangeNotifier {
  String _masterUID = "master";
  String? _user;
  UserMode? _userMode;
  Set<dynamic> categories = {};
  UserBehavior? userBehavior;

  DrugListProvider({this.userBehavior});

  String get masterUID => _masterUID;

  set masterUID(String value) {
    _masterUID = value;
    userBehavior!.masterUID = value;
  }

  String? get user => _user;
  set user(String? value) {
    _user = value;
  }

  UserMode? get userMode => _userMode;
  set userMode(UserMode? value) {
    _userMode = value;
  }

  void setUserBehavior(UserBehavior userBehavior) {
    this.userBehavior = userBehavior;
  }

  bool get isAdmin => userMode == UserMode.isAdmin;

  void clearProvider() {
    // Clear any user-specific data and resources
    categories.clear();
    user = null;
    userMode = null;
    userBehavior = null;
  }

  @override
  void dispose() {
    clearProvider();
    super.dispose();
  }

  Stream<List<Drug>> getDrugsStream() {
    categories = userBehavior!.categories;
    return userBehavior!.getDrugsStream();
  }

  Future<void> addUserNotes(String id, String notes) async {
    if (userBehavior is SyncedUserBehavior) {
      await (userBehavior as SyncedUserBehavior).addUserNotes(id, notes);
    } else {
      throw Exception("User notes are not supported for this user mode.");
    }
  }

  Future<void> addDrug(Drug drug) async {
    await userBehavior!.addDrug(drug);
  }

  Future<void> deleteDrug(Drug drug) async {
    await userBehavior!.deleteDrug(drug);
  }

  Future<void> copyMasterToUser() async {
    if (userBehavior is CustomUserBehavior) {
      await (userBehavior as CustomUserBehavior).copyMasterToUser();
    } else {
      throw Exception(
          "Copying master drugs is not supported for this user mode.");
    }
  }

  Future<Set<String>> getDrugNamesFromMaster() async {
    if (userBehavior is CustomUserBehavior) {
      return (userBehavior as CustomUserBehavior).getDrugNamesFromMaster();
    } else {
      throw Exception(
          "Getting drug names from master is not supported for this user mode.");
    }
  }

  Future<void> addDrugsFromMaster(List<String> drugNames) async {
    if (userBehavior is CustomUserBehavior) {
      await (userBehavior as CustomUserBehavior).addDrugsFromMaster(drugNames);
    } else {
      throw Exception(
          "Adding drugs from master is not supported for this user mode.");
    }
  }

  Future<bool> getDataStatus() async {
    if (userBehavior is CustomUserBehavior) {
      return await (userBehavior as CustomUserBehavior).getDataStatus();
    } else {
      throw Exception(
          "Getting data status is not supported for this user mode.");
    }
  }
}
