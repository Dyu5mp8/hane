import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/admin/admin_nutrition_editview.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

class AdminSourceTile extends StatelessWidget {
  final Source source;

  AdminSourceTile({required this.source});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminNutritionEditview(source: source),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Centers vertically
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 4),
                  ...source.displayContents.map((string) => Text(string)).toList(),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}