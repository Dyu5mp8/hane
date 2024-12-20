import "package:flutter/material.dart";
import 'package:hane/drugs/drug_list_view/drawers/menu_drawer.dart';

class SyncedUserMenuDrawer extends MenuDrawer {
  const SyncedUserMenuDrawer({super.key});

  @override List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [const SyncedModeTile(),
    const SendReviewTile()];
  }
}
