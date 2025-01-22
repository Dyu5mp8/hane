import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';

class Intermittent extends Nutrition {
  
  final IntermittentSource intermittentSource;
  int quantity;


  Intermittent({
    required this.intermittentSource, this.quantity = 0
  }) : super(source: intermittentSource);



  @override
  double kcalPerDay() {
    // Example calculation, adjust as necessary
    return intermittentSource.kcalPerUnit * quantity;
  }

  @override
  double proteinPerDay() {
    // Example calculation, adjust as necessary
    return intermittentSource.proteinPerUnit * quantity;
  }

@override
double volumePerDay() {
  return (intermittentSource.mlPerUnit) * quantity;
}

  @override
  double lipidsPerDay() {
    // Example calculation, adjust as necessary
    return intermittentSource.lipidsPerUnit * quantity;
  }

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 0) quantity--;
  }



}