import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drawers/user_feedback.dart';


class ReadFeedbackView extends StatelessWidget {
  final List<UserFeedback> feedback;

  const ReadFeedbackView({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: ListView.builder(
        itemCount: feedback.length,
        itemBuilder: (context, index) {
          return FeedbackTile(feedback: feedback[index]);
        },
      ),
    );
  }
}


class FeedbackTile extends StatelessWidget {
  final UserFeedback feedback;

  const FeedbackTile({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(feedback.feedback),
      subtitle: Text(feedback.timestamp),
    );
  }
}
