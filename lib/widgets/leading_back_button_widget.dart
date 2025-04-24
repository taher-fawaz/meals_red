import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeadingBackButtonWidget extends StatelessWidget {
  const LeadingBackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      color: Colors.white,
      splashRadius: 20.r,
    );
  }
}
