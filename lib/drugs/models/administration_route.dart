enum AdministrationRoute {
  po,
  iv,
  im,
  sc,
  rect,
  inh,
  nasal,
  other;

  static AdministrationRoute? fromString(String? value) {
  
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case "po":
        return AdministrationRoute.po;
      case "iv":
        return AdministrationRoute.iv;
      case "im":
        return AdministrationRoute.im;
      case "sc":
        return AdministrationRoute.sc;
      case "nasalt":
        return AdministrationRoute.nasal;
      case "inh":
        return AdministrationRoute.inh;
      default:
        return AdministrationRoute.other;
    }


  }

  @override
  String toString() {
    switch (this) {
      case AdministrationRoute.po:
        return "Peroralt";
      case AdministrationRoute.iv:
        return "Intravenöst";
      case AdministrationRoute.im:
        return "Intramuskulärt";
      case AdministrationRoute.sc:
        return "Subkutant";
      case AdministrationRoute.rect:
        return "Rektalt";
      case AdministrationRoute.inh:
        return "Inhalation";
      case AdministrationRoute.nasal:
        return "Nasalt";
      case AdministrationRoute.other:
        return "Övrigt";
    }
  }
}