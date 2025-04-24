import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final double price;
  final double calories;
  final String category;
  final String imageUrl;
  final bool isSelected;

  const Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.calories,
    required this.category,
    required this.imageUrl,
    this.isSelected = false,
  });

  Ingredient copyWith({
    String? id,
    String? name,
    double? price,
    double? calories,
    String? category,
    String? imageUrl,
    bool? isSelected,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      calories: calories ?? this.calories,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        calories,
        category,
        imageUrl,
        isSelected,
      ];
}
