import "package:hane/drugs/services/user_behaviors/user_behavior.dart";
import "package:rxdart/rxdart.dart";

class SyncedUserBehavior extends UserBehavior {
  SyncedUserBehavior({required String super.user, required super.masterUID});

  @override
  Stream<List<Drug>> getDrugsStream({bool sortByGeneric = false}) {
    var db = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> drugsCollection = db
        .collection('users')
        .doc(masterUID)
        .collection('drugs');

    Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream =
        drugsCollection.snapshots();

    DocumentReference<Map<String, dynamic>> userNotesDocRef = db
        .collection('users')
        .doc(user)
        .collection('indexes')
        .doc('userNotesIndex');

    Stream<DocumentSnapshot<Map<String, dynamic>>> userNotesStream =
        userNotesDocRef.snapshots();

    // Combine both streams
    return Rx.combineLatest2(drugsStream, userNotesStream, (
      drugsSnapshot,
      userNotesSnapshot,
    ) {
      Map<String, dynamic> userNotesIndex = {};

      // Initialize user notes index if it exists
      if (userNotesSnapshot.exists) {
        userNotesIndex = userNotesSnapshot.data() ?? {};
      }
      // Parse master drugs with error handling
      var masterDrugs =
          drugsSnapshot.docs
              .map((doc) {
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
              })
              .whereType<Drug>()
              .toList(); // Filter out null values

      // Combine the two lists and sort them

      masterDrugs.sort(
        (a, b) => a
            .preferredDisplayName(preferGeneric: sortByGeneric)
            .toLowerCase()
            .compareTo(
              b
                  .preferredDisplayName(preferGeneric: sortByGeneric)
                  .toLowerCase(),
            ),
      );

      return masterDrugs;
    });
  }

  @override
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
