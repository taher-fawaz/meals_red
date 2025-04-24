import 'package:assignment/core/utils/calorie_calculator.dart';

class CalculateDailyCalories {
  double call({
    required String gender,
    required double weight,
    required double height,
    required int age,
  }) {
    return CalorieCalculator.calculateDailyCalories(
      gender: gender,
      weight: weight,
      height: height,
      age: age,
    );
  }
}
