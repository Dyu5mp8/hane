import 'package:flutter/material.dart';


class editButtontoView extends StatelessWidget {
   final Widget destination;
  final IconData icon;

  const editButtontoView({super.key, required this.destination, this.icon = Icons.edit});

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