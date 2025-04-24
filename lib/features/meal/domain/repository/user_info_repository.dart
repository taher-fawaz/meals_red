import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/user_info.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserInfoRepository {
  Future<Either<Failure, void>> saveUserInfo(UserInfo userInfo);
  Future<Either<Failure, UserInfo?>> getLastUserInfo();
}
