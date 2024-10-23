import "package:hane/drugs/services/user_behaviors/user_behavior.dart";
import "package:rxdart/rxdart.dart";

class SyncedUserBehavior extends UserBehavior {

  SyncedUserBehavior({required String user, required String masterUID})
      : super(user: user, masterUID: masterUID);

  @override
  Stream<List<Drug>> getDrugsStream( {bool sortByGeneric = false}) {
    var db = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> drugsCollection =
        db.collection('users').doc(masterUID).collection('drugs');
Query<Map<String, dynamic>> userDrugsCollection = db.collection('users').doc(user).collection('drugs');
    

    Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream =
        drugsCollection.snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> userDrugsStream =
        userDrugsCollection.snapshots();

    DocumentReference<Map<String, dynamic>> userNotesDocRef = db
        .collection('users')
        .doc(user)
        .collection('indexes')
        .doc('userNotesIndex');

    Stream<DocumentSnapshot<Map<String, dynamic>>> userNotesStream =
        userNotesDocRef.snapshots();

    // Combine both streams
   return Rx.combineLatest3(
  userDrugsStream,
  drugsStream,
  userNotesStream,
  (userDrugsSnapshot, drugsSnapshot, userNotesSnapshot) {
    Map<String, dynamic> userNotesIndex = {};

    // Initialize user notes index if it exists
    if (userNotesSnapshot.exists) {
      userNotesIndex = userNotesSnapshot.data() ?? {};
    }

    // Parse userDrugs with error handling
    var userDrugs = userDrugsSnapshot.docs.map((doc) {
      try {
        var drug = Drug.fromFirestore(doc.data());
        drug.id = doc.id;
        return drug;
      } catch (e) {
        // Log and skip the problematic document
        print("Error mapping user drug with ID ${doc.id}: $e");
        return null;
      }
    }).whereType<Drug>().toList(); // Filter out null values

    // Parse master drugs with error handling
    var masterDrugs = drugsSnapshot.docs.map((doc) {
      try {
        var drug = Drug.fromFirestore(doc.data());
        categories.addAll(drug.categories ?? []);
        drug.id = doc.id;

        // Set the userNotes from userNotesIndex
        if (userNotesIndex.containsKey(drug.id)) {
          drug.userNotes = userNotesIndex[drug.id] as String;
        }

        return drug;
      } catch (e) {
        // Log and skip the problematic document
        print("Error mapping master drug with ID ${doc.id}: $e");
        return null;
      }
    }).whereType<Drug>().toList(); // Filter out null values

    // Combine the two lists and sort them
    var allDrugs = [...masterDrugs, ...userDrugs];
    allDrugs.sort(
        (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

    return allDrugs;
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
        drug.id = newDocRef.id;
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

  Future<void> addUserNotes(String id, String notes) async {
    var db = FirebaseFirestore.instance;
    DocumentReference userNotesDocRef = db
        .collection('users')
        .doc(user)
        .collection('indexes')
        .doc('userNotesIndex');
    await userNotesDocRef.set({id: notes}, SetOptions(merge: true));
  }
}
