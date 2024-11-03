import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/ui_components/custom_chip.dart';
import 'package:hane/drugs/ui_components/custom_chip_with_radio.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;

class EditNameDialog extends StatefulWidget {
  final Drug drug;
  final bool isNewDrug;
  const EditNameDialog({super.key, required this.drug, this.isNewDrug = false});

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  List<String> _brandNames = [];
  List<String> _categories = [];
  String? _genericName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic> _suggestedCategories = [
    "Cirkulation",
    "Anestesi",
    "Smärta",
    "Andning",
    "Antidot"
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _nameController.text = widget.drug.name ?? '';
    _brandNames =
        widget.drug.brandNames?.map((e) => e.toString()).toList() ?? [];
    _categories =
        widget.drug.categories?.map((e) => e.toString()).toList() ?? [];
    _suggestedCategories = Provider.of<DrugListProvider>(context, listen: false)
        .categories
        .toList();
    _genericName = widget.drug.genericName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandNameController.dispose();
    super.dispose();
  }

  void _addBrandName() {
    if (_brandNameController.text.isNotEmpty) {
      setState(() {
        _brandNames.add(_brandNameController.text);
        _brandNameController.clear();
      });
    }
  }

  _findSuggestions(String query, List<dynamic> suggestedCategories) {
    List<String> suggestions = [];
    for (String suggestion in suggestedCategories) {
      if (suggestion.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(suggestion);
      }
    }
    return suggestions;
  }

  void _removeBrandName(String name) {
    setState(() {
      _brandNames.remove(name);
    });
  }

  void _addCategory({String? suggestion}) {
    if (suggestion != null && suggestion.isNotEmpty) {
      setState(() {
        _categories.add(suggestion);
        _categoriesController.clear();
      });
    }
    if (_categoriesController.text.isNotEmpty) {
      setState(() {
        _categories.add(_categoriesController.text);
        _categoriesController.clear();
      });
    }
  }

  void _removeCategory(String category) {
    setState(() {
      _categories.remove(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.isNewDrug
              ? const Text('Nytt läkemedel')
              : const Text('Redigera'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (widget.isNewDrug) {
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.close),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_brandNameController.text.isNotEmpty ||
                      _categoriesController.text.isNotEmpty) {
                    String? forgottenBrandNameText =
                        _brandNameController.text.isNotEmpty
                            ? _brandNameController.text
                            : null;
                    String? forgottenCategoryText =
                        _categoriesController.text.isNotEmpty
                            ? _categoriesController.text
                            : null;

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Ej tillagda ändringar'),
                            content: Text(
                                'Ej sparat fält: ${forgottenBrandNameText ?? ''} ${forgottenCategoryText ?? ''}. Spara utan att lägga till de inskrivna fälten?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Avbryt'),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.drug.name = _nameController.text;
                                  widget.drug.brandNames = _brandNames;
                                  widget.drug.categories = _categories;
                                  widget.drug.genericName = _genericName;
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('Ja'),
                              ),
                            ],
                          );
                        });
                  } else {
                    widget.drug.name = _nameController.text;
                    widget.drug.brandNames = _brandNames;
                    widget.drug.categories = _categories;
                    widget.drug.genericName = _genericName;

                    Navigator.pop(context);
                  }
                }
              },
              child: const Icon(Icons.check),
            ),
          ]),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name input

                const SizedBox(height: 40),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                    border: OutlineInputBorder(),
                  ),
                  validator: val.validateName,
                ),

                const SizedBox(height: 50),

                TextFormField(
                  controller: _brandNameController,
                  decoration: InputDecoration(
                    labelText: 'Lägg till synonymer',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        {
                          _addBrandName();
                        }
                      },
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),

                const SizedBox(height: 8),
                // Display brand names as chips
                // Display brand names with an option to select generic name

                Row(
                  children: [
                    const Text(
                      'Om det finns ett generiskt namn, markera detta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                SizedBox(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _brandNames
                        .map((name) => CustomChipWithCheckbox(
                              label: name,
                              isSelected: _genericName == name,
                              onSelected: (selected) {
                                setState(() {
                                  _genericName = selected! ? name : null;
                                });
                              },
                              onDeleted: () => _removeBrandName(name),
                            ))
                        .toList(),
                  ),
                ),
                // Categories input
                const SizedBox(height: 19),
                TypeAheadField<String>(
                  decorationBuilder: (context, child) => Container(
                    key: UniqueKey(),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: child,
                  ),
                  hideKeyboardOnDrag: true,
                  hideOnUnfocus: true,
                  hideWithKeyboard: true,
                  hideOnEmpty: true,
                  direction: VerticalDirection.up,
                  hideOnLoading: true,
                  hideOnError: true,
                  hideOnSelect: true,
                  suggestionsCallback: (search) =>
                      _findSuggestions(search, _suggestedCategories),
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Lägg till kategorier',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            {
                              _addCategory(suggestion: controller.text);
                            }
                          },
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    );
                  },
                  itemBuilder: (context, category) {
                    return ListTile(
                      dense: true,
                      title:
                          Text(category, style: const TextStyle(fontSize: 13)),
                      tileColor: Colors.white,
                    );
                  },
                  onSelected: (category) {
                    _addCategory(suggestion: category);
                  },
                ),

                const SizedBox(height: 8),
                // Display categories as chips

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _categories
                      .map((category) => CustomChip(
                            label: category,
                            onDeleted: () => _removeCategory(category),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
