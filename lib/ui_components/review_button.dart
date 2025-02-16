import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:icons_plus/icons_plus.dart';

class ReviewButton extends StatelessWidget {
  final ReviewStatus status;

  const ReviewButton(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ReviewStatus.waitingOnUser:
        return const Icon(Bootstrap.exclamation_circle,
            color: Color.fromARGB(255, 183, 125, 49));
      case ReviewStatus.userAccepted:
        return const Icon(Bootstrap.check_circle_fill,
            color: Color.fromARGB(255, 183, 125, 49));
      case ReviewStatus.allAccepted:
        return const Icon(Bootstrap.check_circle_fill, color: Colors.green);

      case ReviewStatus.notReviewed:
        return const SizedBox();
    }
  }
}
