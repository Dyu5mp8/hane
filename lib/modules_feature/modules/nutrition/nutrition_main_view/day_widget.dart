import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:provider/provider.dart';

class DayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NutritionViewModel>();

    /// Safely handle null or unexpected values.
    final String dayText = vm.day.toStringAsFixed(0);
      
    /// You can adapt these text styles to your theme or dark mode needs.
    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(

          fontWeight: FontWeight.bold,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(

        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        // Dark background to match the screenshot style; adjust if you have a Theme color for cards.
        color: Theme.of(context).cardColor.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child:Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
  children: [
    GestureDetector(
      onTap: () =>
        vm.setNewDay(vm.day + 1)
      ,
      child: Icon(
        Icons.arrow_upward_rounded,
      
        size: 20,
      ),
    ),

    // Use vertical spacing instead of horizontal
    const SizedBox(height: 8),

    Icon(
      Icons.calendar_month_outlined,

      size: 24,
    ),
    const SizedBox(height: 8),
    GestureDetector(
      onTap:() => vm.setNewDay(vm.day - 1),
      child: Icon(
        Icons.arrow_downward_rounded,
      
        size: 20,
      ),
    ),
  ],
),
    );
  }
}