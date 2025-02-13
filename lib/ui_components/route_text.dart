import "package:flutter/material.dart";
import "package:hane/drugs/drug_detail/dosage_view_handler.dart";
import "package:icons_plus/icons_plus.dart";
import "package:hane/drugs/models/administration_route.dart";

class RouteText extends StatelessWidget {
  final AdministrationRoute route;
  const RouteText({super.key, required this.route});

  Icon? routeIcon({required double iconSize}) {
    switch (route) {
      case AdministrationRoute.po:
        return Icon(FontAwesome.pills_solid, size: iconSize);
      case AdministrationRoute.iv:
        return Icon(FontAwesome.syringe_solid, size: iconSize);
      case AdministrationRoute.im:
        return Icon(FontAwesome.syringe_solid, size: iconSize);
      case AdministrationRoute.sc:
        return Icon(FontAwesome.syringe_solid, size: iconSize);
      case AdministrationRoute.inh:
        return Icon(FontAwesome.lungs_solid, size: iconSize);

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (routeIcon(iconSize: 12) != null) routeIcon(iconSize: 14)!,
        const SizedBox(width: 5),
        Text(route.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
