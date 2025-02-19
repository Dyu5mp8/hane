import "package:hane/drugs/services/user_behaviors/user_behavior.dart";

class CustomUserBehavior extends UserBehavior {
  CustomUserBehavior({required String super.user, required super.masterUID});

  @override
  Stream<List<Drug>> getDrugsStream({bool sortByGeneric = false}) {
    var db = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> drugsCollection = db
        .collection('users')
        .doc(user)
        .collection('drugs');

    Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream =
        drugsCollection.snapshots();

    return drugsStream.map((drugsSnapshot) {
      var drugsList =
          drugsSnapshot.docs
              .map((doc) {
                try {
                  var drug = Drug.fromFirestore(doc.data());
                  categories.addAll(drug.categories ?? []);
                  drug.id = doc.id;
                  return drug;
                } catch (e) {
                  // Log the error and skip the problematic document
                  print("Error mapping drug with ID ${doc.id}: $e");
                  return null;
                }
              })
              .whereType<Drug>()
              .toList(); // Filter out null values

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
  Future<void> addDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;
    CollectionReference drugsCollection = db
        .collection('users')
        .doc(user)
        .collection('drugs');
    DocumentReference indexDocRef = db
        .collection('users')
        .doc(user)
        .collection('indexes')
        .doc("drugIndex");

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
        indexDocRef.set({
          newDocRef.id: drug.lastUpdated,
        }, SetOptions(merge: true));
        drug.id = newDocRef.id; //intended side effect
        return; // Exit early as we are done adding the new drug
      }
      // If the existing drug is different, update it by merging the changes
      await drugsCollection
          .doc(drug.id)
          .set(drug.toJson(), SetOptions(merge: true));
      indexDocRef.set({drug.id!: drug.lastUpdated}, SetOptions(merge: true));
    } catch (e) {
      print("Failed to add drug: $e");
      rethrow; // Rethrow the error to handle it further up the call stack
    }
  }

  @override
  Future<void> deleteDrug(Drug drug) async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference drugsCollection = db
          .collection('users')
          .doc(user)
          .collection('drugs');
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

    CollectionReference<Map<String, dynamic>> masterDrugsCollection = db
        .collection("users")
        .doc(masterUID)
        .collection("drugs");

    CollectionReference<Map<String, dynamic>> userDrugsCollection = db
        .collection("users")
        .doc(user)
        .collection("drugs");

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

        // Copy the data and modify the `changedByUser` field
        Map<String, dynamic> drugData = doc.data();
        drugData['changedByUser'] = true;

        batch.set(userDocRef, drugData);
      }

      await batch.commit();
    } catch (e) {
      print("Failed to copy master drugs to user: $e");
      rethrow;
    }
  }

  Future<Set<String>> getDrugNamesFromMaster({
    String masterUser = 'master',
  }) async {
    try {
      var db = FirebaseFirestore.instance;

      // Fetch the master drug index
      DocumentSnapshot indexSnapshot =
          await db
              .collection('users')
              .doc(masterUser)
              .collection('indexes')
              .doc('drugIndex')
              .get();

      // Fetch the user drug index
      DocumentSnapshot userIndexSnapshot =
          await db
              .collection('users')
              .doc(user)
              .collection('indexes')
              .doc('drugIndex')
              .get();

      if (indexSnapshot.exists) {
        // Retrieve the master and user drug maps (key: drug name, value: timestamp)
        Map<String, dynamic> masterDrugIndex =
            indexSnapshot.get('drugs') as Map<String, dynamic>;
        Map<String, dynamic> userDrugIndex =
            userIndexSnapshot.exists
                ? userIndexSnapshot.data() as Map<String, dynamic>
                : {};

        // Convert master and user drug indexes to Map<String, Timestamp>
        Map<String, Timestamp> masterDrugTimestamps = masterDrugIndex.map(
          (key, value) => MapEntry(key, value as Timestamp),
        );
        Map<String, Timestamp> userDrugTimestamps = userDrugIndex.map(
          (key, value) => MapEntry(key, value as Timestamp),
        );

        // Create a set of keys where the master drug is updated later than the user drug
        Set<String> updatedDrugs =
            masterDrugTimestamps.keys.where((key) {
              // Get the master and user timestamps
              Timestamp? masterTimestamp = masterDrugTimestamps[key];
              Timestamp? userTimestamp = userDrugTimestamps[key];

              // Check if masterTimestamp is null, if so ignore this entry
              if (masterTimestamp == null) {
                return false; // Skip this entry if master timestamp is null
              }

              // Include the drug if the user timestamp is missing or if the master drug is updated later
              return userTimestamp == null ||
                  masterTimestamp.compareTo(userTimestamp) > 0;
            }).toSet();

        return updatedDrugs;
      } else {
        // Master drug index does not exist, return an empty set
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
    CollectionReference userDrugsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('drugs');

    try {
      // Fetch the drugs with the specified names from the master collection
      final snapshot =
          await masterDrugsCollection.where('name', whereIn: drugNames).get();

      // Initialize a Firestore batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add each drug document to the batch
      for (var doc in snapshot.docs) {
        // Create a new document reference in the user's drugs collection
        DocumentReference newDocRef = userDrugsCollection.doc(doc.id);

        // Add the set operation to the batch
        batch.set(newDocRef, doc.data());
      }

      // Commit the batch write
      await batch.commit();
      print("Successfully added drugs from master.");
    } catch (e) {
      print("Failed to add drugs from master: $e");
      rethrow;
    }
  }

  Future<bool> getDataStatus() async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference<Map<String, dynamic>> userDrugsCollection = db
          .collection('users')
          .doc(user)
          .collection('drugs');

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await userDrugsCollection.limit(1).get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Failed to get data status: $e");
      rethrow;
    }
  }
}
