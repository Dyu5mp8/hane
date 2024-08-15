import "package:flutter/material.dart";
import "package:hane/medications/medication_edit/category_edit/category_form.dart";

class CategoryWidget extends StatefulWidget {
  final CategoryForm categoryForm;

  const CategoryWidget({super.key, 
    required this.categoryForm
  });

  @override
  State<CategoryWidget> createState() => _categoryWidgetState();
}

class _categoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: widget.categoryForm.categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategorier',
                  hintText: 'Ange kategorier',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.categoryForm.addcategory();
                });
                
                
                }
            )
          ],
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: _buildcategoryChips(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildcategoryChips() {
    return widget.categoryForm.categories.map((category) {
      return InputChip(
        label: Text(category),
        onDeleted: () {
          setState(() {
            widget.categoryForm.removecategory(category);
          });
     
        },
      );
    }).toList();
  }
}