import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:provider/provider.dart';

class DayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NutritionViewModel>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardColor, // Removed opacity for better clarity
        borderRadius: BorderRadius.circular(
          12,
        ), // Increased border radius for a smoother look
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Softer shadow color
            offset: const Offset(0, 4), // Increased vertical offset for depth
            blurRadius: 12, // Increased blur radius for a more diffused shadow
          ),
        ],
        border: Border.all(
          width: 1,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.2), // Softer border color
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Ensures horizontal centering
        children: [
          GestureDetector(
            onTap: () => vm.setNewDay(vm.day + 1),
            child: Icon(Icons.arrow_upward_rounded, size: 20),
          ),

          // Use vertical spacing instead of horizontal
          const SizedBox(height: 8),

          Icon(
            Icons.calendar_month_outlined,
            color: Theme.of(context).colorScheme.primary,

            size: 24,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              if (vm.day > 0) {
                vm.setNewDay(vm.day - 1);
              }
            },
            child: Icon(Icons.arrow_downward_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
