import "package:hane/drugs/services/user_behaviors/user_behavior.dart";

class CustomUserBehavior extends UserBehavior {
  CustomUserBehavior({required String user, required String masterUID})
      : super(user: user, masterUID: masterUID);
  @override
  Stream<List<Drug>> getDrugsStream() {
    print("CustomUserBehavior getDrugsStream");
    var db = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> drugsCollection =
        db.collection('users').doc(user).collection('drugs');

    Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream =
        drugsCollection.snapshots();

    return drugsStream.map((drugsSnapshot) {
      var drugsList = drugsSnapshot.docs.map((doc) {
        var drug = Drug.fromFirestore(doc.data());
        categories.addAll(drug.categories ?? []);
        drug.id = doc.id;
        return drug;
      }).toList();

      drugsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

      return drugsList;
    });
  }

  @override
  Future<void> addDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;
    CollectionReference drugsCollection =
        db.collection('users').doc(user).collection('drugs');

    try {
      // Mark the drug as changed by the user if not an admin and update the timestamp
      drug.changedByUser = true;
      drug.lastUpdated = Timestamp.now();

      // Check if the drug is new (i.e., it has no ID)
      if (drug.id == null) {
        // Generate a new document reference with an auto-generated ID
        DocumentReference newDocRef = drugsCollection.doc();

        // Save the new drug document to Firestore
        await newDocRef.set(drug.toJson());
        return; // Exit early as we are done adding the new drug
      }
      // If the existing drug is different, update it by merging the changes
      await drugsCollection
          .doc(drug.id)
          .set(drug.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("Failed to add drug: $e");
      rethrow; // Rethrow the error to handle it further up the call stack
    }
  }

  @override
  Future<void> deleteDrug(Drug drug) async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference drugsCollection =
          db.collection('users').doc(user).collection('drugs');
      if (drug.id != null) {
        await drugsCollection.doc(drug.id).delete();
      }
    } catch (e) {
      print("Failed to delete drug: $e");
      rethrow;
    }
  }

  Future<void> copyMasterToUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    CollectionReference<Map<String, dynamic>> masterDrugsCollection =
        db.collection("users").doc(masterUID).collection("drugs");

    CollectionReference<Map<String, dynamic>> userDrugsCollection =
        db.collection("users").doc(user).collection("drugs");

    try {
      var userSnapshot = await userDrugsCollection.limit(1).get();
      if (userSnapshot.docs.isNotEmpty) {
        throw Exception("User already has drugs. Cannot copy master drugs.");
      }

      WriteBatch batch = db.batch();
      QuerySnapshot<Map<String, dynamic>> masterSnapshot =
          await masterDrugsCollection.get();

      for (var doc in masterSnapshot.docs) {
        DocumentReference userDocRef = userDrugsCollection.doc(doc.id);
        batch.set(userDocRef, doc.data());
      }

      await batch.commit();
    } catch (e) {
      print("Failed to copy master drugs to user: $e");
      rethrow;
    }
  }

  Future<Set<String>> getDrugNamesFromMaster(
      {String masterUser = 'master'}) async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentSnapshot indexSnapshot = await db
          .collection('users')
          .doc(masterUser)
          .collection('indexes')
          .doc('drugIndex')
          .get();

      if (indexSnapshot.exists) {
        // Document exists, retrieve the drug names
        List<dynamic> drugNames = indexSnapshot.get('drugs');
        return Set<String>.from(drugNames);
      } else {
        // Document does not exist, return an empty list
        return {};
      }
    } catch (e) {
      print("Failed to retrieve drug names: $e");
      rethrow;
    }
  }

  Future<void> addDrugsFromMaster(List<String> drugNames) async {
    CollectionReference masterDrugsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc('master')
        .collection('drugs');

    try {
      // Await the snapshot
      final snapshot =
          await masterDrugsCollection.where('name', whereIn: drugNames).get();

      // Convert the documents into a list of Drug objects
      final List<Drug> drugs = snapshot.docs
          .map((doc) => Drug.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      for (var drug in drugs) {
        await addDrug(drug);
      }
    } catch (e) {
      print("Failed to add drugs from master: $e");
      rethrow;
    }
  }

  Future<bool> getDataStatus() async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference<Map<String, dynamic>> userDrugsCollection =
          db.collection('users').doc(user).collection('drugs');

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await userDrugsCollection.limit(1).get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Failed to get data status: $e");
      rethrow;
    }
  }
}
