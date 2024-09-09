import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/ui_components/custom_chip.dart';
import 'package:provider/provider.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;

class EditNameDialog extends StatefulWidget {
  final Drug drug;
  const EditNameDialog({super.key, required this.drug});

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  List<String> _brandNames = [];
  List<String> _categories = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _nameController.text = widget.drug.name ?? '';
    _brandNames = widget.drug.brandNames?.map((e) => e.toString()).toList() ?? [];
    _categories = widget.drug.categories?.map((e) => e.toString()).toList() ?? [];
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
 void _removeBrandName(String name) {
    setState(() {
      _brandNames.remove(name);
    });
  }
  void _addCategory() {
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
        title: const Text('Redigera'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: null,
        actions: [
        TextButton(
          onPressed: () {

            Navigator.pop(context);
          },
          child: const Text('Avbryt')
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print("hej");
           

              if (!_brandNameController.text.isEmpty||!_categoriesController.text.isEmpty) {

                String? forgottenBrandNameText =  _brandNameController.text.isNotEmpty ? _brandNameController.text : null;
                String? forgottenCategoryText =  _categoriesController.text.isNotEmpty ? _categoriesController.text : null;

                showDialog(
              context: context,
                      builder: (BuildContext context)  {
                return AlertDialog(
                  title: const Text('Ej tillagda ändringar'),
                  content: Text('Ej sparat fält: ${forgottenBrandNameText ?? ''} ${forgottenCategoryText ?? ''}. Spara utan att lägga till de inskrivna fälten?'),
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
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Ja'),
                    ),
                  ],
                );
              });
             
              }
              else {
                widget.drug.name = _nameController.text;
                widget.drug.brandNames = _brandNames;
                widget.drug.categories = _categories;
              
               Navigator.pop(context);
              }
            }
   
          }
        ,

          child: const Text('Spara'),
        ),
      ]) ,
      
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            
            children: [
              // Name input
              const Text('Namn'),
              const SizedBox(height: 40),
              TextFormField(

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
                    onPressed: (){
                       {
                        _addBrandName();
                      }
                      
                  
                      },
                  ),
          
                ),
                
              ),
          
              const SizedBox(height: 8),
              // Display brand names as chips
              SizedBox(
                height:40,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _brandNames
                      .map((name) => CustomChip(
                            label: name,
                          
                            onDeleted: () => _removeBrandName(name),
                          ))
                      .toList(),
                ),
              ),
              // Categories input
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoriesController,
                decoration: InputDecoration(
                  labelText: 'Lägg till kategorier',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                     {
                        _addCategory();
                      }
                    },
                  ),
                ),
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
      
    );
  }
}