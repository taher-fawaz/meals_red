import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/app_color.dart';
import '../../../../core/themes/app_font.dart';
import '../../../../routes/app_route_path.dart';
import '../../../../widgets/button_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 16.h,
            ),
            color: Colors.black.withOpacity(0.3),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Balanced Meal',
                  style: AppFont.title.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Text(
                  'Craft your ideal meal effortlessly with our app. Select nutritious ingredients tailored to your taste and well-being.',
                  textAlign: TextAlign.center,
                  style: AppFont.lightText.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButtonWidget(
                  label: 'Get Started',
                  callback: () {
                    context.pushNamed(AppRoute.userDetails.name);
                  },
                  paddingHorizontal: 40.w,
                  paddingVertical: 12.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
