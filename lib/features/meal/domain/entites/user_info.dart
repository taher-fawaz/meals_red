import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String gender;
  final double weight;
  final double height;
  final int age;
  final double dailyCaloriesNeeded;

  const UserInfo({
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.dailyCaloriesNeeded,
  });

  @override
  List<Object?> get props => [
        gender,
        weight,
        height,
        age,
        dailyCaloriesNeeded,
      ];
}
