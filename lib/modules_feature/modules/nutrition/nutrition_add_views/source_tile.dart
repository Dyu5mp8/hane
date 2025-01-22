import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';



class SourceTile extends StatelessWidget {

  Source source;

  SourceTile({required this.source});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(source.name),
      isThreeLine: true,
      dense: false,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: source.displayContents
        .map((string) => Text(string)) // Map each string to a Text widget
        .toList()),

       
    
    );
  }
}