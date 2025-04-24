import 'package:assignment/core/themes/app_color.dart';
import 'package:assignment/core/themes/app_font.dart';
import 'package:flutter/material.dart';

class CalorieProgressIndicatorWidget extends StatelessWidget {
  final double targetCalories;
  final double currentCalories;

  const CalorieProgressIndicatorWidget({
    Key? key,
    required this.targetCalories,
    required this.currentCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = targetCalories > 0
        ? (currentCalories / targetCalories).clamp(0.0, 1.0)
        : 0.0;

    final bool isWithinRange = currentCalories >= targetCalories * 0.9 &&
        currentCalories <= targetCalories * 1.1;
    final Color progressColor =
        isWithinRange ? AppColor.success : AppColor.warning;

    return Column(
      children: [
        // Progress bar
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              // Progress fill
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Perfect target marker (at 100%)
              Positioned(
                left: MediaQuery.of(context).size.width -
                    32 -
                    32, // Adjust based on padding
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.black,
                ),
              ),

              // Lower bound marker (at 90%)
              Positioned(
                left: (MediaQuery.of(context).size.width - 32 - 32) * 0.9,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

              // Upper bound marker (at 110%)
              Positioned(
                left: (MediaQuery.of(context).size.width - 32 - 32) * 1.1 >
                        MediaQuery.of(context).size.width - 32 - 32
                    ? MediaQuery.of(context).size.width - 32 - 32
                    : (MediaQuery.of(context).size.width - 32 - 32) * 1.1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),

        // Calorie text
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentCalories.toStringAsFixed(0)} Cal',
                style: AppFont.caption,
              ),
              Text(
                'out of ${targetCalories.toStringAsFixed(0)} Cal',
                style: AppFont.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
