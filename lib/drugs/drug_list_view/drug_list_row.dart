import 'package:flutter/material.dart';

import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class DrugListRow extends StatelessWidget {
  final Drug _drug;
  final void Function()? onDetailPopped;

  const DrugListRow(this._drug, {super.key, this.onDetailPopped});

  @override
  Widget build(BuildContext context) {
    if (_drug.id == null) {
      return const ListTile(
        title: Text(
          "Felaktig data",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {

      return Consumer<DrugListProvider>(builder: (context, provider, child) {
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(right: 16.0, top: 0, bottom: 5),
          minLeadingWidth: 0,
          leading: Container(
            width: 5,
            color: _drug.changedByUser
                ? Theme.of(context).primaryColor
                : Colors.transparent,
          ),
          title: Text(
            _drug.preferredDisplayName(preferGeneric: provider.preferGeneric),
          ),
          subtitle: Text(_drug.preferredSecondaryNames(
              preferGeneric: provider.preferGeneric)?.join(', ') ?? ''),
          trailing:
              _drug.hasUnreadMessages ? _buildNewMessageChip(context) : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<Drug>(
                        create: (_) => Drug.from(_drug)),
                    ChangeNotifierProvider<EditModeProvider>(
                        create: (_) => EditModeProvider()),
                  ],
                  child: const DrugDetailView(),
                ),
              ),
            ).then((_) {
              if (onDetailPopped != null) {
                onDetailPopped!();
              }
            });
          },
        );
      });
    }
  }

  Chip _buildNewMessageChip(BuildContext context) {
    return Chip(
      label: Text('Nytt meddelande',
          style: Theme.of(context).textTheme.labelSmall),
      labelPadding: const EdgeInsets.all(0),
      backgroundColor: const Color.fromARGB(255, 252, 220, 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color.fromARGB(0, 126, 36, 29),
          width: 1,
        ),
      ),
    );
  }
Widget _buildSubtitle(BuildContext context, {preferGeneric = false}) {
  List<dynamic>? brandNames;

  // Check if brandNames is null or empty
  if (_drug.brandNames == null || _drug.brandNames!.isEmpty) {
    return const SizedBox.shrink(); // No brand names, return empty widget
  }


  if (preferGeneric == true) {
    brandNames = _drug.preferredSecondaryNames(preferGeneric: preferGeneric);
  } else {
    // Use the original brandNames list
    brandNames = _drug.brandNames!;
  }

  // Check again after fetching the brand names
  if (brandNames == null || brandNames.isEmpty) {
    return const SizedBox.shrink(); // No brand names after processing
  }

  // Construct the rich text for brand names
  List<TextSpan> textSpans = [];

  if (preferGeneric == true) {
    // Apply the specified TextStyle to all names
    for (var name in brandNames) {
      textSpans.add(TextSpan(
        text: name,
        style: const TextStyle(
        
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      ));

      // Add a comma separator if it's not the last item
      if (name != brandNames.last) {
        textSpans.add(const TextSpan(text: ', '));
      }
    }
  } else {
    // Use the existing logic when preferGeneric is false or null
    String? genericName = _drug.genericName; // Assuming `genericName` is in Drug class

    for (var name in brandNames) {
      textSpans.add(TextSpan(
        text: name,
        style: name == genericName
            ? const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              )
            : const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
      ));

      // Add a comma separator if it's not the last item
      if (name != brandNames.last) {
        textSpans.add(const TextSpan(text: ', '));
      }
    }
  }

  return Text.rich(
    TextSpan(
      children: textSpans,
    ),
  );
}
}
