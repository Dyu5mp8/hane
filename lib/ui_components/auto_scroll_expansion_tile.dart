import 'package:flutter/material.dart';

class AutoScrollExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;

  const AutoScrollExpansionTile({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<AutoScrollExpansionTile> createState() =>
      _AutoScrollExpansionTileState();
}

class _AutoScrollExpansionTileState extends State<AutoScrollExpansionTile> {
  final GlobalKey _tileKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: _tileKey,
      title: widget.title,
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
          // Wait briefly for the expansion animation before scrolling.
          Future.delayed(const Duration(milliseconds: 300), () {
            // Ensure the expanded tile is visible.
            Scrollable.ensureVisible(
              _tileKey.currentContext!,
              duration: const Duration(milliseconds: 300),
              alignment: 0.0,
            );
          });
        }
      },
      children: widget.children,
    );
  }
}
