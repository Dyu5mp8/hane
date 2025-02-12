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
}