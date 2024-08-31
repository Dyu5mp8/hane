import "package:flutter/material.dart";
import "package:hane/drugs/controllers/dosageViewHandler.dart";
import "package:hugeicons/hugeicons.dart";
import "package:icons_plus/icons_plus.dart";

class RouteText extends StatelessWidget {


  final AdministrationRoute route;
  const RouteText({super.key, required this.route});

  String routeText () {

      switch (route) {
        case AdministrationRoute.po:
          return "Oralt";
        case AdministrationRoute.iv:
          return "Intravenöst";
        case AdministrationRoute.im:
          return "Intramuskulärt";
        case AdministrationRoute.sc:
          return "Subkutant";
        case AdministrationRoute.inh:
          return "Inhalation";
       case AdministrationRoute.nasal:
          return "Nasalt";
       default:
          return "Annat";
  }

  }

  Icon? routeIcon ({required double iconSize}) {
      
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
        SizedBox(width: 5),
        Text(routeText()),
      ],
    );
  }
}