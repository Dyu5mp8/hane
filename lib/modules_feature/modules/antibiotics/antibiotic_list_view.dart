import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/antibiotics/models/antibiotic.dart';
import 'package:hane/modules_feature/modules/antibiotics/antibiotic_detail_view.dart';
import 'package:hane/ui_components/category_chips.dart';
import 'package:hane/ui_components/search_field.dart'; // import reusable category chips widget

class AntibioticsListView extends StatefulWidget {
  const AntibioticsListView({Key? key}) : super(key: key);

  @override
  _AntibioticsListViewState createState() => _AntibioticsListViewState();
}

class _AntibioticsListViewState extends State<AntibioticsListView> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  
  // Cache the future
  late final Future<List<Antibiotic>> _antibioticsFuture;

  @override
  void initState() {
    super.initState();
    _antibioticsFuture = Antibiotic.fetchFromCacheFirstThenServer();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter antibiotics based on search query and selected category
  // Filter antibiotics based on search query and selected category
  List<Antibiotic> _filterAntibiotics(List<Antibiotic> antibiotics) {
    final query = _searchQuery.toLowerCase();
    return antibiotics.where((antibiotic) {
      final nameMatches = (antibiotic.name ?? '').toLowerCase().contains(query);
      final categoryMatches =
          _selectedCategory == null || antibiotic.category == _selectedCategory;
      return nameMatches && categoryMatches;
    }).toList();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Antibiotika (RAF)'),
  
    ),
    body: FutureBuilder<List<Antibiotic>>(
      future: _antibioticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final antibiotics = snapshot.data ?? [];

        // Extract categories once from the fetched data
        final allCategories = antibiotics
            .map((a) => a.category)
            .where((category) => category != null)
            .toSet()
            .toList();

        final filteredAntibiotics = _filterAntibiotics(antibiotics);

        return Column(
          children: [
            SearchField(
              controller: _searchController,
              placeholder: 'Sök',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            CategoryChips(
              categories: allCategories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            Expanded(
              child: filteredAntibiotics.isEmpty
                  ? const Center(child: Text('Inga antibiotika matchar din sökning'))
                  : ListView.builder(
                      itemCount: filteredAntibiotics.length,
                      itemBuilder: (context, index) {
                        final antibiotic = filteredAntibiotics[index];
                        final name = antibiotic.name ?? 'Unnamed Antibiotic';
                        return ListTile(
                          title: Text(name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AntibioticDetailView(
                                    antibiotic: antibiotic),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    ),
  );
}
}
