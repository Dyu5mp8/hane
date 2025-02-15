import 'package:flutter/material.dart';
import 'package:hane/drugs/models/administration_route.dart';
import 'package:icons_plus/icons_plus.dart';


extension AdministrationRouteIcon on AdministrationRoute {
  IconData? get icon {
    switch (this) {
      case AdministrationRoute.po:
        return FontAwesome.pills_solid;
      case AdministrationRoute.iv:
        return FontAwesome.syringe_solid;
      case AdministrationRoute.im:
        return FontAwesome.syringe_solid;
      case AdministrationRoute.sc:
        return FontAwesome.syringe_solid; 
      case AdministrationRoute.inh:
        return FontAwesome.lungs_solid;
      default :
        return null;
    }
  }
}