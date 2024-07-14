import "dart:ffi";

import "package:hane/models/medication/dose.dart";


class DoseConverter{
  bool convertingTime = false;
  bool convertingWeight = false;
  bool convertingConcentration = false;


  void setConversionMode({
    bool convertingTime = false, 
    bool convertingWeight = false, 
    bool convertingConcentration = false,
  }) {
    // Set the conversion mode
    this.convertingTime = convertingTime;
    this.convertingWeight = convertingWeight;
    this.convertingConcentration = convertingConcentration;
  }

Dose convert(Dose? dose) {  

  return 

}



}