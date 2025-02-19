import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/nutrition/models/continuous.dart';
import 'package:hane/modules_feature/modules/nutrition/models/intermittent.dart';
import 'package:hane/modules_feature/modules/nutrition/models/nutrition.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Unknown nutrition type'),
      );
    }
  }
}

class InfusionTile extends StatelessWidget {
  final Continuous infusion;

  const InfusionTile({Key? key, required this.infusion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContinousSource source = infusion.source as ContinousSource;
    final vm = Provider.of<NutritionViewModel>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Delete Button Row
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align vertically centered
            children: [
              Expanded(
                child: Text(
                  source.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  vm.removeNutrition(infusion);
                },
              ),
            ],
          ),

          // Infusion Rate and Kcal per day Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Infusionstakt: ${infusion.getRate().toStringAsFixed(0)} ml/h",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Volym per dag: ${infusion.volumePerDay().toStringAsFixed(0)} ml",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Text(
                "Kcal per dag: ${infusion.kcalPerDay().toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          // Slider
          SfSlider(
            min: source.rateRangeMin ?? 0,
            max: source.rateRangeMax ?? 100,
            value: infusion.mlPerHour,
            onChanged: (value) {
              vm.updateRate(infusion, value);
            },
          ),
        ],
      ),
    );
  }
}

class IntermittentTile extends StatelessWidget {
  final Intermittent nutrition;

  const IntermittentTile({Key? key, required this.nutrition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NutritionViewModel>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  nutrition.source.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      viewModel.decreaseQuantity(nutrition);
                      if (nutrition.quantity == 0) {
                        viewModel.removeNutrition(nutrition);
                      }
                    },
                  ),
                  Text(
                    '${nutrition.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      viewModel.increaseQuantity(nutrition);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      viewModel.removeNutrition(nutrition);
                    },
                  ),
                ],
              ),
              // Optional: Add more actions if needed
            ],
          ),

          // Kcal and Protein per day Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kcal per dag: ${nutrition.kcalPerDay()}",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "Protein per dag: ${nutrition.proteinPerDay()}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          // Quantity Control Row
        ],
      ),
    );
  }
}
