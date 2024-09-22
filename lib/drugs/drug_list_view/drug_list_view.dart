import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/login/user_status.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/drug_list_view/drawers.dart';
import 'package:hane/drugs/drug_list_view/drug_list_row.dart';

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

  MenuDrawer buildDrawer(BuildContext context, Set<String>? userDrugNames) {
    var userMode = Provider.of<DrugListProvider>(context).userMode;
  switch (userMode) {
    case UserMode.isAdmin:
      return const AdminMenuDrawer();
    case UserMode.syncedMode:
      return const SyncedUserMenuDrawer();
    case UserMode.customMode:
      return CustomUserMenuDrawer(userDrugNames: userDrugNames);
    default:
      return CustomUserMenuDrawer(userDrugNames: userDrugNames);
  }
}


  @override
  Widget build(BuildContext context) {

    List<Drug>? drugs = Provider.of<List<Drug>?>(context);
    Set<String>? drugNames = drugs
        ?.map((drug) => drug.name)
        .where((name) => name != null)
        .map((name) => name!)
        .toSet();

    if (drugs == null) {
      // Show a loading indicator while the drugs are loading
      return Scaffold(
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (drugs.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(context),
        drawer: buildDrawer(context, drugNames),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Inga läkemedel i listan'),
            TextButton.icon(
                onPressed: _onAddDrugPressed,
                label: const Text('Lägg till ett läkemedel'),
                icon: const Icon(Icons.add)),
          ],
        )),
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
      drawer: buildDrawer(context, drugNames),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                if (Provider.of<DrugListProvider>(context)
                    .categories
                    .isNotEmpty)
                  _buildCategoryChips(allCategories),
                const SizedBox(height: 30),
              ],
            ),
          ),
          filteredDrugs.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                      child: Text('Inga läkemedel som matchar sökningen')),
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

  void _onAddDrugPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
            builder: (context) => MultiProvider(
      providers: [
        ChangeNotifierProvider<Drug>.value(
            value: Drug(indications: <Indication>[]))
                , // sets the editable drug as the provider drug
        ChangeNotifierProvider<EditModeProvider>.value(
            value: EditModeProvider()) // a provider for the edit mode
      ],
      child: DrugDetailView(isNewDrug: true,)
            )
          ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CupertinoSearchTextField(
        style: Theme.of(context).textTheme.labelLarge,
        controller: _searchController,
        placeholder: 'Sök efter läkemedel',
        onChanged: (value) {
          setState(() {
            _searchQuery = value; // Update the search query as the user types
          });
        },
        onSubmitted: (value) {
          setState(() {
            _searchQuery = value; // Final value after user submits search
          });
        },
      ),
    );
  }

  Widget _buildCategoryChips(List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Wrap(
            spacing: 5.0, // horizontal space between chips
            runSpacing: -8,
            children: [
              ChoiceChip(
                showCheckmark: false,
                label: Text("Alla",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 11)),
                selected: _selectedCategory == null,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Slightly rounded edges
                ),
                onSelected: (bool selected) {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              ),
              ...categories.map((dynamic category) {
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(category,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontSize: 11)),
                  selected: _selectedCategory == category,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Slightly rounded edges
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  final Map<String, String> _drugSearchCache = {};

  List<Drug> _filterDrugs(List<Drug> drugs) {
    final searchQuery = _searchQuery.toLowerCase();

    return drugs.where((drug) {
      // Combine the name and brand names into one searchable string
      if (!_drugSearchCache.containsKey(drug.name)) {
        _drugSearchCache[drug.name!] = [
          drug.name?.toLowerCase(),
          ...?drug.brandNames?.map((brand) => brand.toString().toLowerCase())
        ].join(' ');
      }

      final combinedString = _drugSearchCache[drug.name!];

      // Search within the combined string
      final matchesSearchQuery = combinedString!.contains(searchQuery);
      final matchesCategory = _selectedCategory == null ||
          (drug.categories?.contains(_selectedCategory) ?? false);

      return matchesSearchQuery && matchesCategory;
    }).toList();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Läkemedel'),
          Consumer<DrugListProvider>(
            builder: (context, drugListProvider, child) {
              return drugListProvider.isAdmin ?? false
                  ? const Text(
                      'Admin: ÄNDRINGAR SKER I STAMLISTAN',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 77, 0),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
      // leading: IconButton(
      //   icon: const Icon(Icons.exit_to_app),
      //   onPressed: _onLogoutPressed,
      // ),

      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _onAddDrugPressed,
        ),
      ],
    );
  }
}
