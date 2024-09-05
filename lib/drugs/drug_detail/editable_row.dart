import 'package:flutter/material.dart';

class EditableRow extends StatelessWidget{
  final String text;
  final Widget editDialog;
  final bool isEditMode;
  final TextStyle? textStyle; // TextStyle parameter

  const EditableRow({
    Key? key,
    required this.text,
    required this.editDialog,
    required this.isEditMode,
    this.textStyle, // Optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (context) => editDialog);
            },
            child: Row(
              children: [
                Text(text, style: textStyle ?? Theme.of(context).textTheme.headlineLarge),
                Icon(Icons.edit, color: Colors.grey[600], size: 16),
              ],
            ),
          )
        : Row(
            children: [
              Text(text, style: textStyle ?? Theme.of(context).textTheme.headlineLarge),
            ],
          );
  }
}