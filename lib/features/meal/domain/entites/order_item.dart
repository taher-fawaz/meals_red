import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final Ingredient ingredient;
  final int quantity;

  const OrderItem({
    required this.ingredient,
    required this.quantity,
  });

  OrderItem copyWith({
    Ingredient? ingredient,
    int? quantity,
  }) {
    return OrderItem(
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        ingredient,
        quantity,
      ];
}
