part of 'user_info_bloc.dart';

sealed class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}

final class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserInfo userInfo;

  const UserInfoLoaded(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class UserInfoError extends UserInfoState {
  final String message;

  const UserInfoError(this.message);

  @override
  List<Object> get props => [message];
}
