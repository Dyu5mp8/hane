import "package:flutter/material.dart";
import 'package:hane/drawers/menu_drawer.dart';

class SyncedUserMenuDrawer extends MenuDrawer {
  const SyncedUserMenuDrawer({super.key});

  @override List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [
    const SendReviewTile()];
  }
}
