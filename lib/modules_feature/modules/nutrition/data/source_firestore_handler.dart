import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

mixin SourceFirestoreHandler {
  /// Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch a document by its ID from a specific collection
  /// Fetch a document by its ID from a specific collection
  Future<Source?> fetchDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      final doc =
          await _firestore.collection(collectionPath).doc(documentId).get();
      if (doc.exists && doc.data() != null) {
        return Source.fromJson(doc.data()!, doc.id);
      } else {
        // Document does not exist or has no data
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching document: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Re-throw the error so it can be handled by the caller
    }
  }

  /// Fetch all documents from a specific collection
  Future<List<Source>> fetchAllDocuments({
    required String collectionPath,
  }) async {
    try {
      final querySnapshot = await _firestore.collection(collectionPath).get();
      List<Source> sources =
          querySnapshot.docs.map((doc) {
            var source = Source.fromJson(doc.data(), doc.id);
            return source;
          }).toList();

      return sources;
    } catch (e) {
      print('Error fetching all documents: $e');
      return [];
    }
  }

  /// Add a new document to a collection
  Future<void> addDocument({
    required String collectionPath,
    required Source source,
  }) async {
    var sourceCollection = _firestore.collection(collectionPath);

    try {
      print("checking source id: ${source.id}");
      if (source.id != null) {
        print("updating source with id: ${source.id}");
        // If the drug already has an ID, check if the document exists in Firestore

        DocumentSnapshot<Map<String, dynamic>> existingSourceSnapshot =
            await sourceCollection.doc(source.id).get();

        if (existingSourceSnapshot.exists) {
          // If the existing source is different, update it by merging the changes
          await sourceCollection
              .doc(source.id)
              .set(source.toJson(), SetOptions(merge: true));
        } else {
          await sourceCollection.doc(source.id).set(source.toJson());
        }
      } else {
        final docRef = sourceCollection.doc();
        source.id = docRef.id;

        await docRef.set(source.toJson());
        source.id = docRef.id;
      }
    } catch (e) {
      print('Error adding document: $e');
    }
    return null;
  }

  /// Delete a document by its ID
  Future<bool> deleteDocument({
    required String collectionPath,
    required Source source,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(source.id).delete();
      return true;
    } catch (e) {
      print('Error deleting document: $e');
    }
    return false;
  }
}
