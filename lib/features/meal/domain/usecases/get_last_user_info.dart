import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/user_info.dart';
import 'package:assignment/features/meal/domain/repository/user_info_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastUserInfo {
  final UserInfoRepository repository;

  GetLastUserInfo(this.repository);

  Future<Either<Failure, UserInfo?>> call() async {
    return await repository.getLastUserInfo();
  }
}
