import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hane/Views/homepage.dart';


class editButtontoView extends StatelessWidget {
   final Widget destination;
  final IconData icon;

  editButtontoView({Key? key, required this.destination, this.icon = Icons.edit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
    );
  }
}