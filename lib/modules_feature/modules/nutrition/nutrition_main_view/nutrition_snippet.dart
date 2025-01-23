import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';

class NutritionSnippet extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionSnippet({Key? key, required this.nutrition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Step 1: Check the runtime type
    if (nutrition is Continuous) {
      // Step 2: Cast to the correct subtype
      final infusion = nutrition as Continuous;
      // Step 3: Use a dedicated widget
      return InfusionTile(infusion: infusion);
    } else if (nutrition is Intermittent) {
      final nutr = nutrition as Intermittent;
      return IntermittentTile(nutrition: nutr);
    }
    // Step 4: Handle "unrecognized" subtypes gracefully
    else {
      return const ListTile(
        title: Text('Unknown nutrition type'),
      );
    }
  }
}

class InfusionTile extends StatelessWidget {
  final Continuous infusion;

  const InfusionTile({Key? key, required this.infusion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(infusion.source.name),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Infusionstakt: ${infusion.getRate().toStringAsFixed(0)} ml/h"),
          Text("Kcal per day: ${infusion.kcalPerDay().toStringAsFixed(0)}"),
          Text("Protein per day: ${infusion.proteinPerDay()}"),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          var vm = Provider.of<NutritionViewModel>(context, listen: false);
          infusion.updateRate(infusion.mlPerHour + 10);
          print("totalKcalPerDay: ${infusion.kcalPerDay()}");
        },
      ),
    );
  }
}

class IntermittentTile extends StatelessWidget {
  final Intermittent nutrition;

  const IntermittentTile({Key? key, required this.nutrition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the NutritionViewModel if needed for further updates
    final viewModel = Provider.of<NutritionViewModel>(context, listen: false);

    return ListTile(
      title: Text(nutrition.source.name),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Kcal per day: ${nutrition.kcalPerDay()}"),
          Text("Protein per day: ${nutrition.proteinPerDay()}"),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // shrink to content width
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              viewModel.decreaseQuantity(nutrition);
            },
          ),
          Text('${nutrition.quantity}'), // display current count
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              viewModel.increaseQuantity(nutrition);
              // Update the view model if necessary, e.g. notifyListeners or similar logic
            },
          ),
        ],
      ),
    );
  }
}
