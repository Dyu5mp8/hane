import "package:flutter/material.dart";
import "package:hane/medications/medication_edit/brand_name_edit/brand_name_form.dart";

class BrandNameWidget extends StatefulWidget {
  final BrandNameForm brandNameForm;

  BrandNameWidget({
    required this.brandNameForm
  });

  @override
  State<BrandNameWidget> createState() => _BrandNameWidgetState();
}

class _BrandNameWidgetState extends State<BrandNameWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Add Brand Name'),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: widget.brandNameForm.brandNameController,
                decoration: InputDecoration(
                  labelText: 'Brand Name',
                  hintText: 'Enter brand name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.brandNameForm.addBrandName();
                });
                
                
                }
            )
          ],
        ),

        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: _buildBrandNameChips(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBrandNameChips() {
    return widget.brandNameForm.brandNames.map((brandName) {
      return InputChip(
        label: Text(brandName),
        onDeleted: () {
          setState(() {
            widget.brandNameForm.removeBrandName(brandName);
          });
     
        },
      );
    }).toList();
  }
}