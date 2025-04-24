import 'package:assignment/features/meal/domain/entites/ingredient.dart';

class IngredientModel extends Ingredient {
  const IngredientModel({
    required super.id,
    required super.name,
    required super.price,
    required super.calories,
    required super.category,
    required super.imageUrl,
    super.isSelected = false,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'calories': calories,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
