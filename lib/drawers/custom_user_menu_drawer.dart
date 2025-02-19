import "package:flutter/material.dart";
import 'package:hane/drawers/menu_drawer.dart';

class CustomUserMenuDrawer extends MenuDrawer {
  const CustomUserMenuDrawer({super.key});

  @override
  List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [const SyncedModeTile(), const SendReviewTile()];
  }
}
