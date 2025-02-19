import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class SyncDrugsDialog extends StatefulWidget {
  final Set<String> difference;

  const SyncDrugsDialog({required this.difference, super.key});

  @override
  State<SyncDrugsDialog> createState() => _SyncDrugsDialogState();
}

class _SyncDrugsDialogState extends State<SyncDrugsDialog> {
  late Map<String, bool> selectedItems;

  @override
  void initState() {
    super.initState();
    // Initialize the selectedItems map with the items from difference set
    selectedItems = {for (var item in widget.difference) item: false};
  }

  @override
  Widget build(BuildContext context) {
    if (widget.difference.isEmpty) {
      return AlertDialog(
        content: const Text("Inga nya läkemedel att hämta"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Stäng'),
          ),
        ],
      );
    }

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: AppBar(
        title: const Text('Välj läkemedel att hämta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final checkedItems =
                  selectedItems.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

              // Perform an action with the selected items
              // For example, add selected drugs to the user’s collection
              Provider.of<DrugListProvider>(
                context,
                listen: false,
              ).addDrugsFromMaster(checkedItems);

              // Define the snackBarText based on the number of checked items
              var snackBarText = '';
              if (checkedItems.length > 1) {
                snackBarText =
                    '${checkedItems.length} läkemedel har lagts till';
              } else if (checkedItems.length == 1) {
                snackBarText = '${checkedItems.first} har lagts till';
              } else {
                snackBarText = 'Inga läkemedel har lagts till';
              }

              // Create the SnackBar with the dynamic text
              SnackBar snackBar = SnackBar(content: Text(snackBarText));

              // Show the SnackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Close the dialog twice
              Navigator.of(context).pop(); // Close the first dialog
              Navigator.of(context).pop(); // Close the second dialog
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(
                context,
              ).pop(); // Close the dialog without any action
            },
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.difference.length,
          itemBuilder: (context, index) {
            final item = widget.difference.elementAt(index);
            return ListTile(
              title: Text(item),
              trailing: Checkbox(
                value: selectedItems[item],
                onChanged: (bool? checked) {
                  setState(() {
                    selectedItems[item] = checked ?? false;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
