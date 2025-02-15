import "package:flutter/material.dart";
import "package:hane/ui_components/route_icons.dart";
import "package:hane/drugs/models/administration_route.dart";

class RouteText extends StatelessWidget {
  final AdministrationRoute route;
  const RouteText({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (route.icon != null) Icon(route.icon, size: 14),
        const SizedBox(width: 5),
        Text(route.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
