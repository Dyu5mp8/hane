import "package:flutter/material.dart";


class CategoryForm{

List<dynamic> categories;  

TextEditingController categoryController = TextEditingController();

CategoryForm({required this.categories});

void addcategory(){
  if (categoryController.text.isEmpty) return;
  categories.add(categoryController.text);
  categoryController.clear();  
}


void removecategory(String category){
  categories.remove(category); 
}



}