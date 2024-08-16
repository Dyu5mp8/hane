import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/services/medication_firebase_service.dart';
import 'package:hane/medications/views/medication_list_view/medication_list_row.dart';
import 'package:hane/utils/error_alert.dart';

class MedicationListView extends StatefulWidget {
  @override
  _MedicationListViewState createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  final String user = 'master';
  late MedicationService _medicationService;
  List<Medication> medications = [];
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _medicationService = MedicationService(user: user);
    _fetchMedications();
  }

  Future<void> _fetchMedications({bool forceFromServer = false}) async {
    try {
      List<Medication> fetchedMedications = await _medicationService.getMedications(forceFromServer: forceFromServer);
      setState(() {
        medications = fetchedMedications;
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of categories from the medications, handling null categories
    List<dynamic> categories = medications
        .where((medication) => medication.categories != null) // Filter out medications with null categories
        .expand((medication) => medication.categories!)
        .toSet()
        .toList();

    // Filter medications based on the search query and selected category
    List<Medication> filteredMedications = medications.where((medication) {
      final matchesSearchQuery = medication.name!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || (medication.categories?.contains(_selectedCategory) ?? false);
      return matchesSearchQuery && matchesCategory;
    }).toList();

    final scrollableList = SafeArea(
      child: ListView.builder(
        itemCount: filteredMedications.length,
        itemBuilder: (context, index) {
          return MedicationListRow(filteredMedications[index]);
        },
      ),
    );

    // Search field
    final searchField = Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Sök efter läkemedel',
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

    // ChoiceChips for categories
    final categoryChips = Row(

      children: [Text("Kategori"),
      SizedBox(width: 30),
        ChoiceChip(
          label: Text("Alla"),
          selected: _selectedCategory == null,
          onSelected: (bool selected) {
            setState(() {
              _selectedCategory = selected ? null : null;
            });
          },
        ),

        Wrap(
          children: categories.map((dynamic category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );

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
                  builder: (context) => MedicationEditDetail(
                    medicationForm: MedicationForm(
                      medication: Medication(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Column(
          children: [
            searchField,
            const SizedBox(height: 10),
            if (categories.isNotEmpty) Container(
              padding: EdgeInsets.only(left: 40),
              alignment: Alignment.centerLeft,
              child: categoryChips),
            const SizedBox(height:30),
            Expanded(child: scrollableList),
          ],
        ),
      ),
    );
  }

  Future<void> refreshList() async {
    await _fetchMedications(forceFromServer: true);
  }
}