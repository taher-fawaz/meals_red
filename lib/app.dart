import 'package:assignment/configs/injector/injector_conf.dart';
import 'package:assignment/features/meal/domain/entites/order_item.dart';
import 'package:assignment/features/meal/domain/usecases/calculate_daily_calories.dart';
import 'package:assignment/features/meal/domain/usecases/get_ingredients.dart';
import 'package:assignment/features/meal/domain/usecases/get_last_user_info.dart';
import 'package:assignment/features/meal/domain/usecases/place_order.dart';
import 'package:assignment/features/meal/domain/usecases/save_user_info.dart';
import 'package:assignment/features/meal/presentation/bloc/ingredient/ingredient_bloc.dart';
import 'package:assignment/features/meal/presentation/bloc/order/order_bloc.dart';
import 'package:assignment/features/meal/presentation/bloc/user_info/user_info_bloc.dart';
import 'package:assignment/features/meal/presentation/pages/order_summary_page.dart';
import 'package:assignment/features/meal/presentation/pages/place_order_page.dart';
import 'package:assignment/features/meal/presentation/pages/user_details_page.dart';
import 'package:assignment/features/meal/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/themes/app_theme.dart';
import 'routes/app_route_path.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoBloc>(
          create: (context) => UserInfoBloc(
            calculateDailyCalories: getIt<CalculateDailyCalories>(),
            saveUserInfo: getIt<SaveUserInfo>(),
            getLastUserInfo: getIt<GetLastUserInfo>(),
          ),
        ),
        BlocProvider<IngredientBloc>(
          create: (context) => IngredientBloc(
            getIngredients: getIt<GetIngredients>(),
          ),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(
            placeOrder: getIt<PlaceOrder>(),
            targetCalories: 2500, // Default value, will be updated in route
          ),
        ),
      ],
      child: ScreenUtilInit(
          useInheritedMediaQuery: true,
          designSize: const Size(360, 800),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) => GestureDetector(
                onTap: () => primaryFocus?.unfocus(),
                child: MaterialApp.router(
                  title: 'Balanced Meal',
                  theme: AppTheme.light,
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppRouter.router,
                ),
              )),
    );
  }
}
