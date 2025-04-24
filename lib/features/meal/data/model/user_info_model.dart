import 'package:assignment/features/meal/domain/entites/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required super.gender,
    required super.weight,
    required super.height,
    required super.age,
    required super.dailyCaloriesNeeded,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      gender: json['gender'],
      weight: json['weight'],
      height: json['height'],
      age: json['age'],
      dailyCaloriesNeeded: json['dailyCaloriesNeeded'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'weight': weight,
      'height': height,
      'age': age,
      'dailyCaloriesNeeded': dailyCaloriesNeeded,
    };
  }
}
