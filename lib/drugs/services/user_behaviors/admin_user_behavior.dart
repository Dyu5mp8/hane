import "package:hane/drugs/services/user_behaviors/user_behavior.dart";

class AdminUserBehavior extends UserBehavior {

  AdminUserBehavior({required String masterUID}) : super(masterUID: masterUID);
  @override
  Stream<List<Drug>> getDrugsStream() {
    var db = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> drugsCollection =
        db.collection('users').doc(masterUID).collection('drugs');

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
        db.collection('users').doc(masterUID).collection('drugs');

    try {
      // Mark the drug as changed by the user if not an admin and update the timestamp
      drug.changedByUser = false;
      drug.lastUpdated = Timestamp.now();

      // Check if the drug is new (i.e., it has no ID)
      if (drug.id == null) {
        // Generate a new document reference with an auto-generated ID
        DocumentReference newDocRef = drugsCollection.doc();

        // Save the new drug document to Firestore
        await newDocRef.set(drug.toJson());
        await addDrugToIndex(newDocRef.id, drug.lastUpdated!);

        return; // Exit early as we are done adding the new drug
      }

      // If the drug already has an ID, check if the document exists in Firestore
      DocumentSnapshot existingDrugSnapshot =
          await drugsCollection.doc(drug.id).get();

      if (existingDrugSnapshot.exists) {
        // If the existing drug is different, update it by merging the changes
        await drugsCollection
            .doc(drug.id)
            .set(drug.toJson(), SetOptions(merge: true));
      } else {
        // If the document doesn't exist, create it using the provided ID
        await drugsCollection.doc(drug.id).set(drug.toJson());
      }
      await addDrugToIndex(drug.id!, drug.lastUpdated!);
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
          db.collection('users').doc(masterUID).collection('drugs');
      if (drug.id != null) {
        await drugsCollection.doc(drug.id).delete();

        await removeDrugFromIndex(drug.id!);
      }
    } catch (e) {
      print("Failed to delete drug: $e");
      rethrow;
    }
  }

  Future<void> addDrugToIndex(String id, Timestamp timestamp) async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentReference indexDocRef = db
          .collection('users')
          .doc(masterUID)
          .collection('indexes')
          .doc('drugIndex');

      // Check if the document exists
      DocumentSnapshot snapshot = await indexDocRef.get();

      if (snapshot.exists) {
        // Document exists, update it with the new ID and timestamp as a key-value pair
        await indexDocRef.update({id: timestamp});
      } else {
        // Document does not exist, create it with the first key-value pair
        await indexDocRef.set({
          id: timestamp
        });
      }
    } catch (e) {
      print("Failed to add drug ID and timestamp to index: $e");
      rethrow;
    }
  }

  Future<void> removeDrugFromIndex(String id) async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentReference indexDocRef = db
          .collection('users')
          .doc(user)
          .collection('indexes')
          .doc('drugIndex');

      // Check if the document exists
      DocumentSnapshot snapshot = await indexDocRef.get();

      if (snapshot.exists) {
        // Document exists, update it by removing the key-value pair for the drug ID
        print(id);
        await indexDocRef.update({
          id: FieldValue
              .delete() // Remove the key-value pair where the key is the drug ID
        });
      } else {
        print("Index document does not exist. No need to remove.");
      }
    } catch (e) {
      print("Failed to remove drug ID from index: $e");
      rethrow;
    }
  }
}
