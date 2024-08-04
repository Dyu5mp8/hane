import "package:flutter/material.dart";


class BrandNameForm{

List<dynamic> brandNames;  

TextEditingController brandNameController = TextEditingController();

BrandNameForm({required this.brandNames});

void addBrandName(){
  if (brandNameController.text.isEmpty) return;
  brandNames.add(brandNameController.text);
  brandNameController.clear();  
}


void removeBrandName(String brandName){
  brandNames.remove(brandName); 
}



}