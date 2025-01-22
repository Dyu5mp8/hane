import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';

class AddNutritionView extends StatelessWidget {
  const AddNutritionView({Key? key}) : super(key: key);

  // Fetch data from Firestore
  Future<Map<SourceType, List<Source>>> fetchSourcesGroupedByType() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('nutritions') // Firestore collection name
        .get();

    final sources =
        querySnapshot.docs.map((doc) => Source.fromJson(doc.data())).toList();

    // Group by SourceType
    return {
      for (var type in SourceType.values)
        type: sources.where((s) => s.type == type).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lägg till Nutrition"),
      ),
      body: FutureBuilder<Map<SourceType, List<Source>>>(
        future: fetchSourcesGroupedByType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Fel: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final groupedSources = snapshot.data!;

            // ListView for vertical scrolling of categories
            return ListView(
              // Optional: Bouncing scroll effect for iOS-like feel
              physics: const BouncingScrollPhysics(),
              children: groupedSources.entries.map((entry) {
                final sourceType = entry.key;
                final sources = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        sourceType.displayName, // Swedish display name
                        style: Theme.of(context).textTheme.bodyLarge
                      ),
                    ),

                    // Horizontally scrolling list of items
                    SizedBox(
                      height: 160, // Increase to fit content better
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: sources.length,
                        itemBuilder: (context, index) {
                          final source = sources[index];
                          return Container(
                            // Give each item a consistent width
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Example: an image or icon at the top
                                    // If you have an image URL in `source`, you can replace
                                    // the placeholder Icon with an Image.network(...) widget.
                                    Expanded(
                                      child: Center(
                                        child: Icon(
                                          Icons.food_bank_outlined,
                                          size: 48,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Source name
                                    Text(
                                      source.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    // Additional info from displayContents
                                    const SizedBox(height: 4),
                                    for (final content in source.displayContents)
                                      Text(
                                        content,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("Ingen data hittades"));
          }
        },
      ),
    );
  }
}