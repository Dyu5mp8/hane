import "package:flutter/material.dart";
import 'package:hane/drawers/menu_drawer.dart';
import 'package:hane/drawers/drawer_header.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class CustomUserMenuDrawer extends MenuDrawer { @override List<Widget> buildUserSpecificTiles(BuildContext context) {
    return [
    const SendReviewTile()];
  }
}
