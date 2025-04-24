class CalorieCalculator {
  static double calculateDailyCalories({
    required String gender,
    required double weight,
    required double height,
    required int age,
  }) {
    if (gender.toLowerCase() == 'female') {
      return 655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
    } else {
      return 666.47 + (13.75 * weight) + (5 * height) - (6.75 * age);
    }
  }
}
