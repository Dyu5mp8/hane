import "package:firebase_auth/firebase_auth.dart";
import "package:hane/drugs/services/user_behaviors/user_behavior.dart";
import 'package:rxdart/rxdart.dart';

class AdminUserBehavior extends UserBehavior {

  AdminUserBehavior({required String masterUID}) : super(masterUID: masterUID);
  @override
@override

@override
Stream<List<Drug>> getDrugsStream() {
  var db = FirebaseFirestore.instance;
  Query<Map<String, dynamic>> drugsCollection =
      db.collection('users').doc(masterUID).collection('drugs');

  // Get current user ID
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Stream of user's last read timestamps
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream =
      db.collection('users').doc(userId).snapshots();

  // Stream of drugs
  Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream =
      drugsCollection.snapshots();

  // Combine the streams using switchMap
  return userStream.switchMap((userSnapshot) {
    Map<String, dynamic> lastReadTimestamps =
        userSnapshot.data()?['lastReadTimestamps'] ?? {};

    return drugsStream.map((drugsSnapshot) {


      var drugsList = drugsSnapshot.docs.map((doc) {
        try {
          var drugData = doc.data();

          var drug = Drug.fromFirestore(drugData);
          drug.id = doc.id;

          // Get the last message timestamp from the drug data
          Timestamp? lastMessageTimestamp = drugData['lastMessageTimestamp'];


          // Get the user's last read timestamp for this drug
          Timestamp? userLastReadTimestamp = lastReadTimestamps[drug.id];

          // Determine if there are unread messages
          if (lastMessageTimestamp != null &&
              (userLastReadTimestamp == null ||
                  lastMessageTimestamp.compareTo(userLastReadTimestamp) > 0)) {
            drug.hasUnreadMessages = true;
          } else {
            drug.hasUnreadMessages = false;
          }

          return drug;
        } catch (e) {
          // Log the error and skip the problematic document
          print("Error mapping document with ID ${doc.id}: $e");
          return null;
        }
      }).whereType<Drug>().toList(); // Filter out null values

      drugsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

      return drugsList;
    });
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
        drug.id = newDocRef.id; //intended side effect of updating passed drugs id.

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
          .doc(masterUID)
          .collection('indexes')
          .doc('drugIndex');

      // Check if the document exists
      DocumentSnapshot snapshot = await indexDocRef.get();



      if (snapshot.exists) {
        // Document exists, update it by removing the key-value pair for the drug ID
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