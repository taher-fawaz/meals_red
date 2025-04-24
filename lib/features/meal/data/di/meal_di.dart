import 'package:assignment/configs/injector/injector_conf.dart';
import 'package:assignment/features/meal/data/datasource/ingredient_remote_data_source.dart';
import 'package:assignment/features/meal/data/datasource/order_remote_data_source.dart';
import 'package:assignment/features/meal/data/datasource/user_info_local_data_source.dart';
import 'package:assignment/features/meal/data/repository/ingredient_repository_impl.dart';
import 'package:assignment/features/meal/data/repository/order_repository_impl.dart';
import 'package:assignment/features/meal/data/repository/user_info_repository_impl.dart';
import 'package:assignment/features/meal/domain/repository/ingredient_repository.dart';
import 'package:assignment/features/meal/domain/repository/order_repository.dart';
import 'package:assignment/features/meal/domain/repository/user_info_repository.dart';
import 'package:assignment/features/meal/domain/usecases/calculate_daily_calories.dart';
import 'package:assignment/features/meal/domain/usecases/get_ingredients.dart';
import 'package:assignment/features/meal/domain/usecases/get_last_user_info.dart';
import 'package:assignment/features/meal/domain/usecases/place_order.dart';
import 'package:assignment/features/meal/domain/usecases/save_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealDependencies {
  MealDependencies._();
  static void init() {
    // Data sources
    getIt.registerLazySingleton<IngredientRemoteDataSource>(
      () => FirebaseIngredientRemoteDataSource(
          firestore: getIt<FirebaseFirestore>()),
    );

    getIt.registerLazySingleton<OrderRemoteDataSource>(
      () => ApiOrderRemoteDataSource(client: getIt()),
    );

    getIt.registerLazySingleton<UserInfoLocalDataSource>(
      () => SharedPrefsUserInfoLocalDataSource(
          sharedPreferences: getIt<SharedPreferences>()),
    );

    // Repositories
    getIt.registerLazySingleton<IngredientRepository>(
      () => IngredientRepositoryImpl(
          remoteDataSource: getIt<IngredientRemoteDataSource>()),
    );

    getIt.registerLazySingleton<OrderRepository>(
      () =>
          OrderRepositoryImpl(remoteDataSource: getIt<OrderRemoteDataSource>()),
    );

    getIt.registerLazySingleton<UserInfoRepository>(
      () => UserInfoRepositoryImpl(
          localDataSource: getIt<UserInfoLocalDataSource>()),
    );

    // Use cases
    getIt.registerLazySingleton(
      () => CalculateDailyCalories(),
    );

    getIt.registerLazySingleton(
      () => GetIngredients(getIt<IngredientRepository>()),
    );

    getIt.registerLazySingleton(
      () => GetLastUserInfo(getIt<UserInfoRepository>()),
    );

    getIt.registerLazySingleton(
      () => PlaceOrder(getIt<OrderRepository>()),
    );

    getIt.registerLazySingleton(
      () => SaveUserInfo(getIt<UserInfoRepository>()),
    );
  }
}
