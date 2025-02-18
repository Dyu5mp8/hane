import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_indication_dialog.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:reorderable_tabbar/reorderable_tabbar.dart';
import 'package:provider/provider.dart';

class IndicationTabs extends StatefulWidget {
  const IndicationTabs({super.key});

  @override
  State<IndicationTabs> createState() => _IndicationTabsState();
}

class _IndicationTabsState extends State<IndicationTabs> {
  double _scrollPosition = 0.0;
  bool _moreLeft = false;
  bool _moreRight = false;
  final ScrollController _scrollController = ScrollController();

  // Instead of creating our own TabController, we use the parent's one.
  TabController? _parentTabController;
  List<GlobalKey> _tabKeys = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollMetrics);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _updateScrollMetrics();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtain the parent's TabController from the DefaultTabController.
    final controller = DefaultTabController.of(context);
    if (controller != _parentTabController) {
      _parentTabController?.removeListener(_handleTabChange);
      _parentTabController = controller;
      _parentTabController?.addListener(_handleTabChange);
    }

    // Get indications list from the Drug provider.
    final drug = context.watch<Drug>();
    final List<Indication> indications = drug.indications ?? [];

    // Ensure we have one GlobalKey per tab.
    if (_tabKeys.length != indications.length) {
      _tabKeys = List.generate(indications.length, (_) => GlobalKey());
    }
  }

  void _handleTabChange() {
    // When the parent's TabController index changes (and is settled),
    // scroll the selected tab into view.
    if (_parentTabController != null && !_parentTabController!.indexIsChanging) {
      _scrollToTab(_parentTabController!.index);
    }
  }

  void _scrollToTab(int index) {
    if (index < _tabKeys.length) {
      final keyContext = _tabKeys[index].currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    }
  }

  void _updateScrollMetrics() {
    if (_scrollController.hasClients) {
      final pos = _scrollController.position;
      setState(() {
        _scrollPosition = pos.pixels;
        _moreLeft = pos.pixels > pos.minScrollExtent;
        _moreRight = pos.pixels < pos.maxScrollExtent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollMetrics);
    _scrollController.dispose();
    _parentTabController?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editMode = context.watch<EditModeProvider>().editMode;
    final drug = context.watch<Drug>();
    final List<Indication> indications = drug.indications ?? [];

    // Build the tab bar widget based on editMode.
    Widget tabBarWidget;
    if (editMode) {
      tabBarWidget = ReorderableTabBar(
        controller: _parentTabController,
        buildDefaultDragHandles: false,
        unselectedLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 61, 61, 61),
        ),
        labelColor: Theme.of(context).colorScheme.onSurface,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        tabBorderRadius: BorderRadius.circular(5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).primaryColor,
        ),
        // Adding an onTap callback so that when a tab is chosen,
        // we scroll that tab into view.
        onTap: (index) => _scrollToTab(index),
        tabs: indications.asMap().entries.map((entry) {
          final index = entry.key;
          final indication = entry.value;
          return Tab(
            key: _tabKeys[index],
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Transform.scale(
                    scaleX: 0.6,
                    origin: const Offset(-10, 0),
                    child: const Icon(
                      Icons.drag_handle,
                      size: 30,
                    ),
                  ),
                ),
                Text(indication.name),
              ],
            ),
          );
        }).toList(),
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex != newIndex) {
            setState(() {
              final temp = indications.removeAt(oldIndex);
              indications.insert(newIndex, temp);
              drug.indications = indications;
              drug.updateDrug();
            });
          }
        },
      );
    } else {
      tabBarWidget = TabBar(
        controller: _parentTabController,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        isScrollable: true,

        onTap: (index) => _scrollToTab(index),
        tabs: indications.asMap().entries.map((entry) {
          final index = entry.key;
          final indication = entry.value;
          return Tab(
            key: _tabKeys[index],
            text: indication.name,
          );
        }).toList(),
      );
    }

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: const Border.symmetric(
          horizontal: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (editMode)
            Container(
              width: 40,
             decoration: BoxDecoration(
        color: Theme.of(context)
            .canvasColor, // Set a solid, non-transparent background color
      ),
              child: IconButton(
                onPressed: () {
                  final newIndication =
                      Indication(isPediatric: false, name: '', notes: '');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<Drug>.value(
                        value: drug,
                        child: EditIndicationDialog(
                          indication: newIndication,
                          withDosages: true,
                          isNewIndication: true,
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_sharp),
                iconSize: 25,
                color: Colors.black,
                padding: EdgeInsets.zero,
              ),
            ),
          Flexible(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: tabBarWidget,
                ),
                // Left gradient overlay.
                if (_moreLeft)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 40,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Theme.of(context).canvasColor,
                              Theme.of(context).canvasColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Right gradient overlay.
                if (_moreRight)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 40,
                    child: IgnorePointer(
                      child: Container(
                        child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
                        padding: const EdgeInsets.only(right: 0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Theme.of(context).canvasColor,
                              Theme.of(context).canvasColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}