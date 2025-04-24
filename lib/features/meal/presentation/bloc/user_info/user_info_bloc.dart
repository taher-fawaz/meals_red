import 'package:assignment/core/utils/failure_converter.dart';
import 'package:assignment/features/meal/domain/entites/user_info.dart';
import 'package:assignment/features/meal/domain/usecases/calculate_daily_calories.dart';
import 'package:assignment/features/meal/domain/usecases/get_last_user_info.dart';
import 'package:assignment/features/meal/domain/usecases/save_user_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final CalculateDailyCalories calculateDailyCalories;
  final SaveUserInfo saveUserInfo;
  final GetLastUserInfo getLastUserInfo;

  UserInfoBloc({
    required this.calculateDailyCalories,
    required this.saveUserInfo,
    required this.getLastUserInfo,
  }) : super(UserInfoInitial()) {
    on<CalculateCaloriesEvent>(_onCalculateCalories);
    on<LoadUserInfoEvent>(_onLoadUserInfo);
  }

  void _onCalculateCalories(
    CalculateCaloriesEvent event,
    Emitter<UserInfoState> emit,
  ) async {
    emit(UserInfoLoading());
    try {
      final dailyCaloriesNeeded = calculateDailyCalories(
        gender: event.gender,
        weight: event.weight,
        height: event.height,
        age: event.age,
      );

      final userInfo = UserInfo(
        gender: event.gender,
        weight: event.weight,
        height: event.height,
        age: event.age,
        dailyCaloriesNeeded: dailyCaloriesNeeded,
      );

      final result = await saveUserInfo(userInfo);
      result.fold(
        (failure) => emit(UserInfoError(mapFailureToMessage(failure))),
        (_) => emit(UserInfoLoaded(userInfo)),
      );
    } catch (e) {
      emit(UserInfoError(e.toString()));
    }
  }

  void _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<UserInfoState> emit,
  ) async {
    emit(UserInfoLoading());
    final result = await getLastUserInfo();
    result.fold(
      (failure) => emit(UserInfoError(mapFailureToMessage(failure))),
      (userInfo) {
        if (userInfo != null) {
          emit(UserInfoLoaded(userInfo));
        } else {
          emit(UserInfoInitial());
        }
      },
    );
  }
}
