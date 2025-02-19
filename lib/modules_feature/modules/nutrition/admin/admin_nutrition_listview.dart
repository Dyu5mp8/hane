import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/admin/admin_nutrition_editview.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';
import 'package:hane/modules_feature/modules/nutrition/admin/admin_source_tile.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Source;

class AdminNutritionListview extends StatefulWidget {
  const AdminNutritionListview({Key? key}) : super(key: key);

  @override
  _AdminNutritionListviewState createState() => _AdminNutritionListviewState();
}

class _AdminNutritionListviewState extends State<AdminNutritionListview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lägg till Nutrition")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('nutritions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Fel: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final sources =
                snapshot.data!.docs.map((doc) {
                  final data = doc.data();
                  if (data is Map<String, dynamic>) {
                    return Source.fromJson(data, doc.id);
                  } else {
                    throw Exception(
                      'Document data is not a Map<String, dynamic>',
                    );
                  }
                }).toList();

            final groupedSources = {
              for (var type in SourceType.values)
                type: sources.where((s) => s.type == type).toList(),
            };

            final nonEmptyGroupedSources =
                groupedSources.entries
                    .where((entry) => entry.value.isNotEmpty)
                    .toList();

            if (nonEmptyGroupedSources.isEmpty) {
              return const Center(child: Text("Ingen data hittades"));
            }

            return ListView.builder(
              itemCount: nonEmptyGroupedSources.length,
              itemBuilder: (context, index) {
                final type = nonEmptyGroupedSources[index].key;
                final sources = nonEmptyGroupedSources[index].value;

                return StickyHeader(
                  header: Container(
                    height: 50.0,
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      type.displayName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  content: Column(
                    children:
                        sources
                            .map((source) => AdminSourceTile(source: source))
                            .toList(),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Ingen data hittades"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to NutritionAdmin to add a new source
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminNutritionEditview()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Lägg till Nutrition',
      ),
    );
  }
}
