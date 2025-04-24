import 'package:assignment/core/themes/app_color.dart';
import 'package:assignment/core/themes/app_font.dart';
import 'package:flutter/material.dart';
import '../../domain/entites/ingredient.dart';

class IngredientCardWithCounter extends StatelessWidget {
  final Ingredient ingredient;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const IngredientCardWithCounter({
    Key? key,
    required this.ingredient,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: DecorationImage(
                image: NetworkImage(ingredient.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ingredient Name
                Text(
                  ingredient.name,
                  style: AppFont.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Calories
                Text(
                  '${ingredient.calories.toStringAsFixed(0)} Cal',
                  style: AppFont.caption,
                ),

                const SizedBox(height: 8),

                // Price and Counter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\$${ingredient.price.toStringAsFixed(0)}',
                      style: AppFont.subtitle
                          .copyWith(fontWeight: FontWeight.bold),
                    ),

                    // Counter
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.secondaryBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // Decrease button
                          _buildCounterButton(
                            icon: Icons.remove,
                            color: AppColor.error,
                            onTap: onDecrease,
                          ),

                          // Quantity
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              quantity.toString(),
                              style: AppFont.subtitle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Increase button
                          _buildCounterButton(
                            icon: Icons.add,
                            color: AppColor.primary,
                            onTap: onIncrease,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }
}
