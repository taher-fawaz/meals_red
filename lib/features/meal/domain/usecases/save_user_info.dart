import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/user_info.dart';
import 'package:assignment/features/meal/domain/repository/user_info_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveUserInfo {
  final UserInfoRepository repository;

  SaveUserInfo(this.repository);

  Future<Either<Failure, void>> call(UserInfo userInfo) async {
    return await repository.saveUserInfo(userInfo);
  }
}
