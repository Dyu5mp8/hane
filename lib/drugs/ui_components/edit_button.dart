import 'package:flutter/material.dart';

class editButtontoView extends StatelessWidget {
  final Widget destination;
  final IconData icon;
  final Color iconColor;

  const editButtontoView(
      {super.key,
      required this.destination,
      this.icon = Icons.edit,
      this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: iconColor),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
    );
  }
}
