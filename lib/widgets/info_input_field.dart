import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/themes/app_color.dart';
import '../core/themes/app_font.dart';

class InfoInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffix;

  const InfoInputField({
    Key? key,
    required this.label,
    this.hint,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.subtitle,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter your ${label.toLowerCase()}',
            hintStyle: AppFont.body.copyWith(color: AppColor.textSecondary),
            fillColor: AppColor.secondaryBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixText: suffix,
            suffixStyle: AppFont.body,
          ),
        ),
      ],
    );
  }
}
