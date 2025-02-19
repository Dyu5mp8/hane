import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:hane/drugs/services/user_behaviors/user_behavior.dart";
import 'package:rxdart/rxdart.dart';

class ReviewerUserBehavior extends UserBehavior {
  ReviewerUserBehavior({required super.user, required super.masterUID});

  @override
  Stream<List<Drug>> getDrugsStream({bool sortByGeneric = false}) {
    var db = FirebaseFirestore.instance;

    // Get current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // References to Firestore collections/documents
    Query<Map<String, dynamic>> drugsCollection = db
        .collection('users')
        .doc(masterUID)
        .collection('drugs');

    DocumentReference<Map<String, dynamic>> userDocRef = db
        .collection('users')
        .doc(userId);

    DocumentReference<Map<String, dynamic>> userNotesDocRef = db
        .collection('users')
        .doc(userId)
        .collection('indexes')
        .doc('userNotesIndex');

    // Streams
    Stream<DocumentSnapshot<Map<String, dynamic>>> userStream =
        userDocRef.snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream =
        drugsCollection.snapshots();

    Stream<DocumentSnapshot<Map<String, dynamic>>> userNotesStream =
        userNotesDocRef.snapshots();

    // Combine the streams
    return Rx.combineLatest3(userStream, drugsStream, userNotesStream, (
      userSnapshot,
      drugsSnapshot,
      userNotesSnapshot,
    ) {
      // Handle lastReadTimestamps
      Map<String, dynamic> lastReadTimestamps =
          userSnapshot.data()?['lastReadTimestamps'] ?? {};

      // Handle userNotesIndex
      Map<String, dynamic> userNotesIndex = {};
      if (userNotesSnapshot.exists) {
        userNotesIndex = userNotesSnapshot.data() ?? {};
      }

      var drugsList =
          drugsSnapshot.docs
              .map((doc) {
                try {
                  var drugData = doc.data();

                  var drug = Drug.fromFirestore(drugData);
                  categories.addAll(drug.categories ?? []);
                  drug.id = doc.id;

                  // Get the last message timestamp from the drug data
                  Timestamp? lastMessageTimestamp =
                      drugData['lastMessageTimestamp'];

                  // Get the user's last read timestamp for this drug
                  Timestamp? userLastReadTimestamp =
                      lastReadTimestamps[drug.id];

                  // Determine if there are unread messages
                  if (lastMessageTimestamp != null &&
                      (userLastReadTimestamp == null ||
                          lastMessageTimestamp.compareTo(
                                userLastReadTimestamp,
                              ) >
                              0)) {
                    drug.hasUnreadMessages = true;
                  } else {
                    drug.hasUnreadMessages = false;
                  }

                  // Set the userNotes from userNotesIndex
                  if (userNotesIndex.containsKey(drug.id)) {
                    drug.userNotes = userNotesIndex[drug.id] as String;
                  }

                  return drug;
                } catch (e) {
                  // Log the error and skip the problematic document
                  print("Error mapping document with ID ${doc.id}: $e");
                  return null;
                }
              })
              .whereType<Drug>()
              .toList(); // Filter out null values

      // Sort the drugsList
      drugsList.sort(
        (a, b) => a
            .preferredDisplayName(preferGeneric: sortByGeneric)
            .toLowerCase()
            .compareTo(
              b
                  .preferredDisplayName(preferGeneric: sortByGeneric)
                  .toLowerCase(),
            ),
      );

      return drugsList;
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
