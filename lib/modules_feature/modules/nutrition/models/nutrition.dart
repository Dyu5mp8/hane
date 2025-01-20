// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

abstract class Nutrition {
  final Source source;
  int quantity;

  Nutrition({
    required this.source,
    this.quantity = 0,

  });

  double kcalPerDay();

  double proteinPerDay();

  double volumePerDay();



  void increaseQuantity() {
    quantity++;
  }

    void decreaseQuantity() {
    if(quantity > 0) quantity--;
  }

}
