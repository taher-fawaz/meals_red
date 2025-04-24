import 'package:assignment/core/themes/app_color.dart';
import 'package:assignment/core/themes/app_font.dart';
import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:flutter/material.dart';

class IngredientCounterWidget extends StatelessWidget {
  final Ingredient ingredient;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final double price;

  const IngredientCounterWidget({
    Key? key,
    required this.ingredient,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(ingredient.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: AppFont.subtitle,
                ),
                const SizedBox(height: 4),
                Text(
                  '${ingredient.calories.toStringAsFixed(0)} Cal',
                  style: AppFont.caption,
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${price.toStringAsFixed(0)}',
            style: AppFont.subtitle,
          ),
          const SizedBox(width: 12),

          // Counter
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                color: AppColor.error,
                onTap: onDecrease,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  quantity.toString(),
                  style: AppFont.subtitle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              _buildCounterButton(
                icon: Icons.add,
                color: AppColor.primary,
                onTap: onIncrease,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
