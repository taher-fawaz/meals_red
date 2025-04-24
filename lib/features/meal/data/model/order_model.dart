import 'package:assignment/features/meal/data/model/ingredient_model.dart';
import 'package:assignment/features/meal/domain/entites/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.ingredient,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      ingredient: IngredientModel.fromJson(json['ingredient']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': ingredient.name,
      'total_price': ingredient.price * quantity,
      'quantity': quantity,
    };
  }
}
