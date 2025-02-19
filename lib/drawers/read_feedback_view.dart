import 'package:flutter/material.dart';
import 'package:hane/drawers/user_feedback.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class ReadFeedbackView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final query =
        Provider.of<DrugListProvider>(context, listen: false).userFeedbackQuery;

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: FirestoreQueryBuilder<Map<String, dynamic>>(
        query: query,
        pageSize: 5,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "Ingen feedback ännu",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Container(
            child: ListView.builder(
              itemCount: docs.length + (snapshot.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < docs.length) {
                  final doc = docs[index];
                  // Convert Firestore doc snapshot data into UserFeedback model
                  final feedback = UserFeedback.fromFirestore(doc.data());

                  final formattedDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(feedback.timestamp.toDate());

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Feedback text as the main body
                          Text(
                            feedback.feedback,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8.0),

                          // Email (userId) and date aligned to the bottom right
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(feedback.userId),
                                Text(formattedDate),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          snapshot.fetchMore();
                        },
                        child: const Text("Ladda fler"),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
