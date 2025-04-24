import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/data/datasource/user_info_local_data_source.dart';
import 'package:assignment/features/meal/data/model/user_info_model.dart';
import 'package:assignment/features/meal/domain/entites/user_info.dart';
import 'package:assignment/features/meal/domain/repository/user_info_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserInfoRepositoryImpl implements UserInfoRepository {
  final UserInfoLocalDataSource localDataSource;

  UserInfoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveUserInfo(UserInfo userInfo) async {
    try {
      final userInfoModel = UserInfoModel(
        gender: userInfo.gender,
        weight: userInfo.weight,
        height: userInfo.height,
        age: userInfo.age,
        dailyCaloriesNeeded: userInfo.dailyCaloriesNeeded,
      );
      await localDataSource.cacheUserInfo(userInfoModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserInfo?>> getLastUserInfo() async {
    try {
      final userInfoModel = await localDataSource.getLastUserInfo();
      return Right(userInfoModel);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
