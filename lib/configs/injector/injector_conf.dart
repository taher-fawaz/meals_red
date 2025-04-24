import 'injector.dart';

final getIt = GetIt.I;

Future<void> configureDepedencies() async {
  MealDependencies.init();
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton(
    () => sharedPreferences,
  );

  getIt.registerLazySingleton(
    () => ApiHelper(
      getIt<Dio>(),
    ),
  );

  getIt.registerLazySingleton(
    () => Dio()
      ..interceptors.add(
        getIt<ApiInterceptor>(),
      ),
  );

  getIt.registerLazySingleton(
    () => ApiInterceptor(),
  );

  getIt.registerLazySingleton(
    () => NetworkInfo(
      getIt<InternetConnectionChecker>(),
    ),
  );

  getIt.registerLazySingleton(
    () => InternetConnectionChecker.instance,
  );
}
