import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hane/login/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/drug_list_view/drug_list_row.dart';
import 'package:hane/drugs/drug_edit/drug_detail_form.dart';
import 'package:hane/drugs/drug_edit/drug_edit_detail.dart';



class DrugListView extends StatefulWidget {
  @override
  _DrugListViewState createState() => _DrugListViewState();
}

class _DrugListViewState extends State<DrugListView> {
  String _searchQuery = '';
  String? _selectedCategory;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Drug> drugs = Provider.of<List<Drug>>(context);

    if (drugs.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(child: Text('Inga läkemedel i listan')),
      );
    }

    // Filter drugs based on search query and selected category
    List<Drug> filteredDrugs = _filterDrugs(drugs);

      List<dynamic> allCategories = drugs
      .where((drug) => drug.categories != null)
      .expand((drug) => drug.categories!)
      .toSet()
      .toList();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                if (Provider.of<DrugListProvider>(context).categories.isNotEmpty)
                  _buildCategoryChips(allCategories),
                SizedBox(height: 30),
              ],
            ),
          ),
        
          filteredDrugs.isEmpty
              ? SliverFillRemaining(
                  child: Center(child: Text('No drugs found.')),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return DrugListRow(filteredDrugs[index]);
                    },
                    childCount: filteredDrugs.length,
                  ),
                ),
        ],
      ),
    );
  }

  
  void _onLogoutPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Vill du logga ut?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Provider.of<DrugListProvider>(context, listen: false).clearProvider();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logga ut'),
            ),
          ],
        );
      },
    );
  }

  void _onAddDrugPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: Provider.of<DrugListProvider>(context, listen: false),
          child: DrugEditDetail(
            drugForm: DrugForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Sök efter läkemedel',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

 Widget _buildCategoryChips(List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

  List<Drug> _filterDrugs(List<Drug> drugs) {
    return drugs.where((drug) {
      final matchesSearchQuery = drug.name!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || (drug.categories?.contains(_selectedCategory) ?? false);
      return matchesSearchQuery && matchesCategory;
    }).toList();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Läkemedel'),
          Consumer<DrugListProvider>(
            builder: (context, drugListProvider, child) {
              return drugListProvider.isAdmin ?? false
                  ? Text(
                      'Admin: ÄNDRINGAR SKER I STAMLISTAN',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 77, 0),
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: _onLogoutPressed,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _onAddDrugPressed,
        ),
      ],
    );
  }

}