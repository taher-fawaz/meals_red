import 'package:flutter/material.dart';
import '../core/themes/app_color.dart';
import '../core/themes/app_font.dart';

class AppButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? callback;
  final bool isDisabled;
  final bool isLoading;
  final double paddingHorizontal;
  final double paddingVertical;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? height;

  const AppButtonWidget({
    Key? key,
    required this.label,
    this.callback,
    this.isDisabled = false,
    this.isLoading = false,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isDisabled || isLoading) ? null : callback,
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColor.buttonDisabled
              : backgroundColor ?? AppColor.primary,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  label,
                  style: AppFont.subtitle.copyWith(
                    color: isDisabled
                        ? Colors.grey[600]
                        : textColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
