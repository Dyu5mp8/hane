import "package:flutter/material.dart";
import "package:hane/drugs/ui_components/custom_chip.dart";
import "generic_chip_form.dart";

class GenericChipWidget<T> extends StatefulWidget {
  final GenericChipForm<T> form;
  final String labelText;
  final String? hintText;

  const GenericChipWidget({
    super.key,
    required this.form,
    required this.labelText,
    this.hintText
  });

  @override
  State<GenericChipWidget<T>> createState() => _GenericChipWidgetState<T>();
}

class _GenericChipWidgetState<T> extends State<GenericChipWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width *0.7,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: widget.form.itemController,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 12,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    widget.form.addItem();
                  });
                },
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: _buildItemChips(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItemChips() {
    return widget.form.items.map((item) {
   return CustomChip(
  label: item.toString(),
  onDeleted: () {
    setState(() {
      widget.form.removeItem(item);
    });
  },
);
    }).toList();
  }
}