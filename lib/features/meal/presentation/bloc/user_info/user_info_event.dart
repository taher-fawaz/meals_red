part of 'user_info_bloc.dart';

sealed class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object> get props => [];
}

class CalculateCaloriesEvent extends UserInfoEvent {
  final String gender;
  final double weight;
  final double height;
  final int age;

  const CalculateCaloriesEvent({
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
  });

  @override
  List<Object> get props => [gender, weight, height, age];
}

class LoadUserInfoEvent extends UserInfoEvent {}
