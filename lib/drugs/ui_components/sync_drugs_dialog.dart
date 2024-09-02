import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class SyncDrugsDialog extends StatefulWidget {
  final Set<String> difference;

  const SyncDrugsDialog({
    required this.difference,
    super.key,
  });

  @override
  _SyncDrugsDialogState createState() => _SyncDrugsDialogState();
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
        title: const Text('No Drugs Available'),
        content: const Text('No drugs available to sync.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    }

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: AppBar(
        title: const Text('Select Drugs to Sync'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final checkedItems = selectedItems.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList();

              // Perform an action with the selected items
              // For example, add selected drugs to the user’s collection
              Provider.of<DrugListProvider>(context, listen: false)
                  .addDrugsFromMaster(checkedItems);

              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without any action
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