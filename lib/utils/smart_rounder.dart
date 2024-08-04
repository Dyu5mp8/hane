num smartRound(double value) {
  String str = value.toString();
  int decimalIndex = str.indexOf(".");
  if (decimalIndex == -1) {
    print(value.toStringAsPrecision(3));
    return double.parse(value.toStringAsPrecision(3));
  } else {
    var intString = str.substring(0, decimalIndex);
    var intPartDouble = double.parse(intString);
    if (intString.length >= 3) {
      return double.parse(intPartDouble.toStringAsPrecision(3)).toInt();
    }
    var intPart = double.parse(str.substring(0, decimalIndex));

    var dec = str.substring(decimalIndex);
    var dec_double = double.parse(dec);
    var dec_modified = intPart < 1
        ? dec_double.toStringAsPrecision((3))
        : dec_double.toStringAsPrecision(3 - intString.length);
    var doublePart = double.parse(dec_modified);
    var finalDouble = intPart + doublePart;

    return finalDouble;
  }
}