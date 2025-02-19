import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/login/user_status.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final UserMode? userMode;
  final VoidCallback onAddDrugPressed;
  final Widget Function() searchFieldBuilder;

  const CustomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.userMode,
    required this.onAddDrugPressed,
    required this.searchFieldBuilder,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // Define a fixed height for the AppBar, taking into account the bottom widget if any
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool get canEdit {
    return (widget.userMode == UserMode.isAdmin ||
        widget.userMode == UserMode.customMode);
  }

  @override
  Widget build(BuildContext context) {
    var dlp = Provider.of<DrugListProvider>(context, listen: true);

    bool isAdmin = dlp.isAdmin;
    bool canEdit =
        dlp.userMode == UserMode.isAdmin || dlp.userMode == UserMode.customMode;

    String titleText = _getAppBarTitle(isAdmin);
    Widget adminMessage = _getAdminMessage(isAdmin);
    PreferredSizeWidget? bottomWidget = _getBottomWidgetForAppBar();
    List<Widget> actions = _getAppBarActions(canEdit: canEdit);

    return AppBar(
      forceMaterialTransparency: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(titleText), adminMessage],
      ),
      bottom: bottomWidget,
      actions: actions,
    );
  }

  String _getAppBarTitle(bool isAdmin) {
    // If on the first page (drugs)
    if (widget.selectedIndex == 0) {
      return 'Läkemedel';
    }

    // If on the second page (tools or pending reviews)
    if (widget.selectedIndex == 1) {
      if (isAdmin) {
        return 'Väntande granskningar';
      } else {
        return 'Verktyg';
      }
    }

    if (widget.selectedIndex == 2 && isAdmin) {
      return 'Verktyg';
    }

    // Default fallback (if more pages added in the future)
    return '';
  }

  Widget _getAdminMessage(bool isAdmin) {
    // If on drugs page (0) or waiting reviews page for admin (1), show admin message if admin
    if ((widget.selectedIndex == 0 || widget.selectedIndex == 1) && isAdmin) {
      return const Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 6.0),
        child: Text(
          'Admin: ÄNDRINGAR SKER I STAMLISTAN',
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 255, 77, 0),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  PreferredSizeWidget? _getBottomWidgetForAppBar() {
    // Only show the search field at the bottom of the AppBar if on the drugs page
    if (widget.selectedIndex == 0) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: widget.searchFieldBuilder(),
          ),
        ),
      );
    }

    return null;
  }

  List<Widget> _getAppBarActions({required bool canEdit}) {
    // Only show the add button if on drugs page and canEdit is true
    if (widget.selectedIndex == 0 && canEdit) {
      return [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.onAddDrugPressed,
        ),
      ];
    }
    return [];
  }
}
