import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hane/app_bar.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/services/user_behaviors/behaviors.dart';
import 'package:hane/login/user_status.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drawers/drawers.dart';
import 'package:hane/ui_components/drug_list_row.dart';
import 'package:hane/modules_feature/module_list_view.dart';
import 'package:hane/onboarding/onboarding_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hane/modules_feature/data/modules_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  UserMode? userMode;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late final DrugListProvider provider;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    showTutorialScreenIfNew();
    provider = context.read<DrugListProvider>();
    userMode = provider.userMode ??
        UserMode.syncedMode; //fall back to synced mode
    
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void showTutorialScreenIfNew() async {
    var db = FirebaseFirestore.instance;
    bool? seenTutorial = await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data()?['seenTutorial']);

    if (mounted && (seenTutorial == null || !seenTutorial)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'seenTutorial': true,
      });
    }
  }

  void _onSearchChanged() {
    if (!mounted) return;
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  MenuDrawer buildDrawer(BuildContext context, Set<String>? userDrugNames) {
    switch (userMode) {
      case UserMode.isAdmin:
        return const AdminMenuDrawer();
      case UserMode.reviewer:
        return const ReviewerMenuDrawer();
      case UserMode.syncedMode:
        return const SyncedUserMenuDrawer();
      case UserMode.customMode:
        return CustomUserMenuDrawer();
      default:
        return CustomUserMenuDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Drug>? drugs = Provider.of<List<Drug>?>(context, listen: true);
    Set<String>? drugNames = drugs
        ?.map((drug) => drug.name)
        .where((name) => name != null)
        .map((name) => name!)
        .toSet();

    if (drugs == null) {
      // Show a loading indicator while the drugs are loading
      return Scaffold(
             appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        userMode: userMode,
        onAddDrugPressed: _onAddDrugPressed,
        searchFieldBuilder: _buildSearchField,
      ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (drugs.isEmpty) {
      return Scaffold(
             appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        userMode: userMode,
        onAddDrugPressed: _onAddDrugPressed,
        searchFieldBuilder: _buildSearchField,
      ),
        drawer: buildDrawer(context, drugNames),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inga läkemedel i listan'),
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

    // Filter drugs with pending reviews for the current user
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;
    List<Drug> pendingReviewDrugs = [];
    if (provider.isReviewer) {
      pendingReviewDrugs = drugs.where((drug) {
   
        return drug.isPendingUserReview(currentUserUID!);
      }).toList();
    }

    List<dynamic> allCategories = drugs
        .where((drug) => drug.categories != null)
        .expand((drug) => drug.categories!)
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b)); // Sorts the list alphabetically

        return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        userMode: userMode,
        onAddDrugPressed: _onAddDrugPressed,
        searchFieldBuilder: _buildSearchField,
      ),
      drawer: buildDrawer(context, drugNames),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildHomeScreen(filteredDrugs, allCategories),
          provider.isReviewer ? 
            _buildPendingReviewListView(pendingReviewDrugs) : 
            _buildModulesListView(),
        ],
      ),
      bottomNavigationBar: provider.isReviewer
          ? _buildAdminBottomNavBar(pendingReviewDrugs.length)
          : _buildBottomNavBar(),
    );
  }

  Widget _buildHomeScreen(List<Drug> filteredDrugs, List<dynamic> allCategories) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (provider
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
                    return DrugListRow(
                      filteredDrugs[index],
                      // onDetailPopped: _onDetailsPopped,
                    );
                  },
                  childCount: filteredDrugs.length,
                ),
              ),
      ],
    );
  }

  Widget _buildModulesListView (){
      return ModuleListView(modules: modules);

  }

  Widget _buildPendingReviewListView(List<Drug> pendingReviewDrugs) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        const SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
            ],
          ),
        ),
        pendingReviewDrugs.isEmpty
            ? const SliverFillRemaining(
                child: Center(
                    child: Text('Inga läkemedel med väntande granskningar')),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return DrugListRow(
                      pendingReviewDrugs[index],
                      // onDetailPopped: _onDetailsPopped,
                    );
                  },
                  childCount: pendingReviewDrugs.length,
                ),
              ),
      ],
    );
  }

  void _onAddDrugPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<Drug>(
                        create: (_) => Drug(
                            indications: <Indication>[],
                            changedByUser:
                                true)), // sets the editable drug as the provider drug
                    ChangeNotifierProvider<EditModeProvider>(
                        create: (_) => EditModeProvider()),
                  ],
                  child: const DrugDetailView(
                    isNewDrug: true,
                  ))),
    ).then((_) {
      //  _onDetailsPopped();
    });
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CupertinoSearchTextField(
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(148, 76, 78, 95),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        itemSize: 25,
        controller: _searchController,
        placeholder: 'Sök efter läkemedel',
        onChanged: (value) {
          setState(() {
            if (!mounted) {
              return; // Add this line to check if the widget is still mounted
            }
            _searchQuery = value; // Update the search query as the user types
          });
        },
        onSubmitted: (value) {
          if (!mounted) {
            return; // Add this line to check if the widget is still mounted
          }
          setState(() {
            _searchQuery = value; // Final value after user submits search
          });
        },
      ),
    );
  }

  Widget _buildCategoryChips(List<dynamic> categories) {
    const isWeb = kIsWeb;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Wrap(
            spacing: isWeb ? 5.0 : 5.0, // Adjust spacing for web
            runSpacing: isWeb ? 5.0 : -8, // Adjust vertical space between rows
            alignment: WrapAlignment.start, // Center the chips for web
            children: [
              ChoiceChip(
                visualDensity: VisualDensity.compact,
                side: BorderSide.none,
                showCheckmark: false,
                label: Text("Alla",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: isWeb ? 14 : 11,
                        fontWeight: FontWeight.w800)), // Larger font on web
                selected: _selectedCategory == null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      isWeb ? 12 : 10), // Adjust rounding for web
                ),
                onSelected: (bool selected) {
                  setState(() {
                    _searchController.clear();
                    _selectedCategory = null;
                  });
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              ),
              ...categories.map((dynamic category) {
                return ChoiceChip(
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                  showCheckmark: false,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  label: Text(category,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize:
                              isWeb ? 14 : 11)), // Adjust font size for web
                  selected: _selectedCategory == category,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 4.0), // Increased padding for web
                );
              }),
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
    // Build/cache the combined string of the drug’s name + brand names
    if (!_drugSearchCache.containsKey(drug.name)) {
      _drugSearchCache[drug.name!] = [
        drug.name?.toLowerCase(),
        ...?drug.brandNames?.map((brand) => brand.toString().toLowerCase()),
      ].join(' ');
    }

    final combinedString = _drugSearchCache[drug.name!]!;
    final matchesSearchQuery = combinedString.contains(searchQuery);

    // If there’s a search term, ignore category filtering:
    // Category filtering only applies if the search query is empty.
    bool matchesCategory;
    if (searchQuery.isNotEmpty) {
      matchesCategory = true; 
    } else {
      matchesCategory = _selectedCategory == null ||
          (drug.categories?.contains(_selectedCategory) ?? false);
    }

    return matchesSearchQuery && matchesCategory;
  }).toList();
}

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Läkemedel',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.construction),
          label: 'Verktyg'
        ),
      ],
    );
  }

  BottomNavigationBar _buildAdminBottomNavBar(int pendingCount) {

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Alla läkemedel',
        ),
        BottomNavigationBarItem(
          
          icon: pendingCount > 0?Badge(
            label: Text(
              pendingCount.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: const Icon(Icons.pending)) : const Icon(Icons.pending),
          label: 'Väntande granskningar',
        ),
      ],
    );
  }
}