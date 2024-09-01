import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class SyncDrugsDialog extends StatelessWidget {
  const SyncDrugsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrugListProvider>(
      builder: (context, drugListProvider, child) {
        return FutureBuilder<List<String>>(
          future: drugListProvider.getDifferenceBetweenMasterAndUser(), // Fetching drug names from the provider
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('An error occurred while loading drugs'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

            final items = snapshot.data!;
            final Map<String, bool> selectedItems = {for (var item in items) item: false};

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  titlePadding: EdgeInsets.zero,
                  title: AppBar(
                    title: const Text('Select Drugs'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          setState(() {
                            // Select all items
                             final checkedItems = selectedItems.entries
                              .where((entry) => entry.value)
                              .map((entry) => entry.key)
                              .toList();

                          // Perform an action with the selected items
                          // For example, add selected drugs to the user’s collection
                          drugListProvider.addDrugsFromMaster(checkedItems);

                          Navigator.of(context).pop(); // Close the dialog
                          });
                        
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
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
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
              },
            );
          },
        );
      },
    );
  }
}