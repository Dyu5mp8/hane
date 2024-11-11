num smartRound(double value) {
  String str = value.toString();
  int decimalIndex = str.indexOf(".");
  if (decimalIndex == -1) {
    return double.parse(value.toStringAsPrecision(3)).toInt();
  } else {
    var intString = str.substring(0, decimalIndex);
    var intPartDouble = double.parse(intString);
    if (intString.length >= 3) {
      return double.parse(intPartDouble.toStringAsPrecision(3)).toInt();
    }
    var intPart = double.parse(intString);

    var dec = str.substring(decimalIndex, str.length);
    var decDouble = double.parse(dec);
    var decModified = intPart < 1
        ? decDouble.toStringAsPrecision(3)
        : decDouble.toStringAsPrecision(3 - intString.length);

    var doublePart = double.parse(decModified);

    var finalDouble = intPart + doublePart;
    // Format finalDouble to 2 decimal places
    finalDouble = double.parse(finalDouble.toStringAsFixed(2));
    return finalDouble;
  }
}
