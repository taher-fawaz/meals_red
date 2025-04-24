import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/meal/presentation/pages/welcome_page.dart';
import '../features/meal/presentation/pages/user_details_page.dart';
import '../features/meal/presentation/pages/place_order_page.dart';
import '../features/meal/presentation/pages/order_summary_page.dart';

enum AppRoute {
  home,
  userDetails,
  placeOrder,
  orderSummary;

  String get name => toString().split('.').last;
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Home / Welcome screen
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const WelcomePage(),
      ),

      // User Details screen
      GoRoute(
        path: '/user-details',
        name: AppRoute.userDetails.name,
        builder: (context, state) => const UserDetailsPage(),
      ),

      // Place Order screen
      GoRoute(
        path: '/place-order',
        name: AppRoute.placeOrder.name,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return PlaceOrderPage(args: args);
        },
      ),

      // Order Summary screen
      GoRoute(
        path: '/order-summary',
        name: AppRoute.orderSummary.name,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return OrderSummaryPage(args: args);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state}'),
      ),
    ),
  );
}
