import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/services/medication_list_provider.dart';
import 'package:hane/medications/views/medication_list_view/medication_list_row.dart';
import 'package:provider/provider.dart';

class MedicationListView extends StatefulWidget {
  @override
  _MedicationListViewState createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    setState(() {
      _isLoading = false;
    });
  }


  Future<void> _fetchMedications() async {
    MedicationListProvider medicationListProvider = Provider.of<MedicationListProvider>(context, listen: false);
    print('Fetching medications');
    await medicationListProvider.queryMedications(isGettingDefaultList: false, forceFromServer: true);

  }

  @override
  Widget build(BuildContext context) {
    var medicationListProvider = Provider.of<MedicationListProvider>(context,listen:true);

    // Get the list of categories from the medications, handling null categories
    List<dynamic> categories = medicationListProvider.medications
        .where((medication) => medication.categories != null) // Filter out medications with null categories
        .expand((medication) => medication.categories!)
        .toSet()
        .toList();

    // Filter medications based on the search query and selected category
    List<Medication> filteredMedications = medicationListProvider.medications.where((medication) {
      final matchesSearchQuery = medication.name!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || (medication.categories?.contains(_selectedCategory) ?? false);
      return matchesSearchQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Läkemedel'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: Provider.of<MedicationListProvider>(context, listen: false),
                    child: MedicationEditDetail(
                      medicationForm: MedicationForm(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],

      ),
body: _isLoading
    ? Center(child: CircularProgressIndicator())
    : RefreshIndicator.adaptive(
        onRefresh: _fetchMedications,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Search field
                  searchFieldWidget(),
                  const SizedBox(height: 10),
                  
                  // Category Chips
                  if (categories.isNotEmpty)
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: categoryChipsWidget(categories),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            filteredMedications.isEmpty
                ? SliverFillRemaining(
                    child: Center(child: Text('No medications found.')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MedicationListRow(filteredMedications[index]);
                      },
                      childCount: filteredMedications.length,
                    ),
                  ),
          ],
        ),
      ),
);
  }

  Widget searchFieldWidget() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Sök efter läkemedel',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
    );
  }

  Widget categoryChipsWidget(List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Wrap(
            spacing: 5.0, // horizontal space between chips
            runSpacing: -8,
            children: [
              ChoiceChip(
                showCheckmark: false,
                label: Text("Alla", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 11)),
                selected: _selectedCategory == null,
                 shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Slightly rounded edges
      
      ),
                onSelected: (bool selected) {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              ),
              ...categories.map((dynamic category) {
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(category, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 11)),
                  selected: _selectedCategory == category,
                   shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Slightly rounded edges
      
      ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}