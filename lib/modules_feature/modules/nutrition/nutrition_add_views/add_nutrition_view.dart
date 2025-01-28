import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:provider/provider.dart';
import 'package:hane/modules_feature/modules/nutrition/data/source_firestore_handler.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AddNutritionView extends StatefulWidget {
  const AddNutritionView({Key? key}) : super(key: key);

  @override
  _AddNutritionViewState createState() => _AddNutritionViewState();
}

class _AddNutritionViewState extends State<AddNutritionView> with SourceFirestoreHandler {
  late Future<Map<SourceType, List<Source>>> _futureSources;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureSources = fetchSourcesGroupedByType();
  }

  // Fetch data from Firestore
  Future<Map<SourceType, List<Source>>> fetchSourcesGroupedByType() async {
    final sources = await fetchAllDocuments(collectionPath: 'nutritions');
    return {
      for (var type in SourceType.values)
        type: sources.where((s) => s.type == type).toList(),
    };
  }

  // Filter sources based on search query
  Map<SourceType, List<Source>> _filterSources(
      Map<SourceType, List<Source>> groupedSources) {
    if (_searchQuery.isEmpty) {
      return groupedSources;
    }

    final lowerCaseQuery = _searchQuery.toLowerCase();

    return {
      for (var entry in groupedSources.entries)
        entry.key: entry.value
            .where((source) =>
                source.name.toLowerCase().contains(lowerCaseQuery) ||
                source.displayContents
                    .any((content) => content.toLowerCase().contains(lowerCaseQuery)))
            .toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lägg till nutritionskälla"),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Sök',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),
          // Expanded List
          Expanded(
            child: FutureBuilder<Map<SourceType, List<Source>>>(
              future: _futureSources,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Fel: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final groupedSources = _filterSources(snapshot.data!);

                  // Flatten the grouped data for ListView
                  List<Widget> listItems = [];

                  groupedSources.forEach((type, sources) {
                    if (sources.isEmpty) return;

                    listItems.add(
                      StickyHeader(
                        header: Container(
                          width: double.infinity,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            type.displayName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        content: Column(
                          children: sources.map((source) {
                            return SourceCard(source: source);
                          }).toList(),
                        ),
                      ),
                    );
                  });

                  if (listItems.isEmpty) {
                    return const Center(child: Text("Inga resultat matchade sökningen."));
                  }

                  return ListView.separated(
                    itemCount: listItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      return listItems[index];
                    },
                  );
                } else {
                  return const Center(child: Text("Ingen data hittades"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SourceCard extends StatelessWidget {
  final Source source;

  const SourceCard({Key? key, required this.source}) : super(key: key);

  void _handleAddNutrition(NutritionViewModel vm) {
    if (source is IntermittentSource) {
              vm.addNutrition(Intermittent(intermittentSource: source as IntermittentSource,
                quantity: 1,
              ));
            } else if (source is ContinousSource) {
              ContinousSource c = source as ContinousSource;
              vm.addNutrition(Continuous(continuousSource: c, mlPerHour: c.rateRangeMin ?? 20)
          
              );
   
            }
    // Handle add nutrition event
  }
  @override
  Widget build(BuildContext context) {
     final viewModel = Provider.of<NutritionViewModel>(context);
    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
  
        title: Text(
          source.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: source.displayContents.map((content) {
            return Text(
              content,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }).toList(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
           
            
            _handleAddNutrition(viewModel);
            Navigator.pop(context);
            
            // Handle add nutrition event
          },
        ),
        onTap: () {

             
            _handleAddNutrition(viewModel);
            Navigator.pop(context);
          // Handle tap event, e.g., navigate to detail or add nutrition
        },
      ),
    );
  }
}