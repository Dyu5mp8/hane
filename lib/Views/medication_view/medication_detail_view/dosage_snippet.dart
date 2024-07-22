import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hane/Views/medication_view/medication_detail_view/dosageViewHandler.dart';
import 'package:hane/models/medication/bolus_dosage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hane/models/medication/medication.dart';

class DosageSnippet extends StatefulWidget {
  final Dosage dosage;
  final DosageViewHandler dosageViewHandler;

  


  DosageSnippet({
    Key? key,
    required this.dosage,
    required this.dosageViewHandler
  }) : super(key: key);

  @override
  _DosageSnippetState createState() => _DosageSnippetState();
}

class _DosageSnippetState extends State<DosageSnippet> with SingleTickerProviderStateMixin{
  late final controller = SlidableController(this);


  @override
  Widget build(BuildContext context) {
    return
       Slidable(
              // Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),

              // The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: const [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.share,
                    label: 'Share',
                  ),
                ],
              ),

              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 2,
                    onPressed: (_) => controller.openEndActionPane(),
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    onPressed: (_) => controller.close(),
                   backgroundColor: const Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                ],
              ),

              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: ListTile(
                trailing:  SizedBox(
                  width: 50,
                  child: ConversionOptionMinature(dosageViewHandler: widget.dosageViewHandler),
                ),
                dense: true,
                title: Text(widget.dosageViewHandler.showDosage()),
                        
      ),
              );
            
  }
}

class ConversionOptionMinature extends StatelessWidget {
  final DosageViewHandler dosageViewHandler;
  final double iconSize; 


  const ConversionOptionMinature({
    required this.dosageViewHandler,
    this.iconSize = 15.0,  // Default value set here.
  });

  @override
  Widget build(BuildContext context) {
    print("building conversion option minature");


      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          if (dosageViewHandler.ableToConvert().concentration) Icon(Icons.medication_liquid, size: iconSize),
          if (dosageViewHandler.ableToConvert().time) Icon(Icons.timer_rounded,size: iconSize),
          if (dosageViewHandler.ableToConvert().weight) Icon(Icons.scale, size: iconSize),
          
        ],
      );

  }
}