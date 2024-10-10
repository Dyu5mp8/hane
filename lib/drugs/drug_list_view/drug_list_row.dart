import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';

class DrugListRow extends StatelessWidget {
  final Drug _drug;

  const DrugListRow(this._drug, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_drug.name == null) {
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
          _drug.name!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: _buildBrandNamesText(context),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<Drug>.value(
                      value: Drug.from(_drug)), // sets the editable drug
                  ChangeNotifierProvider<EditModeProvider>.value(
                      value: EditModeProvider()), // a provider for the edit mode
                ],
                child: DrugDetailView(),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildBrandNamesText(BuildContext context) {
    if (_drug.brandNames == null || _drug.brandNames!.isEmpty) {
      return const SizedBox.shrink(); // No brand names, return empty widget
    }

    // Get the list of brand names
    List<dynamic> brandNames = _drug.brandNames!;
    String? genericName = _drug.genericName; // Assuming `genericName` is in Drug class

    // Construct the rich text for brand names
    List<TextSpan> textSpans = [];

    for (var name in brandNames) {
      textSpans.add(TextSpan(
        text: name,
        style: name == genericName
            ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontStyle: FontStyle.italic)
            : const TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
      ));

      // Add a comma separator if it's not the last item
      if (name != brandNames.last) {
        textSpans.add(const TextSpan(text: ', '));
      }
    }

    return Text.rich(
      TextSpan(
        children: textSpans,
      ),
    );
  }
}