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

  @override
  Widget build(BuildContext context) {
    var drugListProvider = Provider.of<DrugListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Läkemedel'),
            if (drugListProvider.isAdmin ?? false)
              Text(
                'Admin: ÄNDRINGAR SKER I STAMLISTAN',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 77, 0),
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Vill du logga ut?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Avbryt'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        FirebaseAuth.instance.signOut();
                        drugListProvider.clearProvider();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Text('Logga ut'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
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
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Drug>>(
        stream: drugListProvider.getDrugsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No drugs found.'));
          }

          // Extract categories for the category chips
          List<dynamic> categories = snapshot.data!
              .where((drug) => drug.categories != null)
              .expand((drug) => drug.categories!)
              .toSet()
              .toList();

          // Reset _selectedCategory if it is no longer available
          if (_selectedCategory != null && !categories.contains(_selectedCategory)) {
            
              _selectedCategory = null;
            };
          

          // Filter drugs based on search query and selected category
          List<Drug> filteredDrugs = snapshot.data!.where((drug) {
            final matchesSearchQuery = drug.name!.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesCategory = _selectedCategory == null || (drug.categories?.contains(_selectedCategory) ?? false);
            return matchesSearchQuery && matchesCategory;
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    searchFieldWidget(),
                    const SizedBox(height: 10),
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
          );
        },
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
            spacing: 5.0,
            runSpacing: -8,
            children: [
              ChoiceChip(
                showCheckmark: false,
                label: Text("Alla", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 11)),
                selected: _selectedCategory == null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
                    borderRadius: BorderRadius.circular(20),
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