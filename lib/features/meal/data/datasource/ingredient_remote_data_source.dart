import 'package:assignment/features/meal/data/model/ingredient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IngredientRemoteDataSource {
  Future<List<IngredientModel>> getIngredients();
}

class FirebaseIngredientRemoteDataSource implements IngredientRemoteDataSource {
  final FirebaseFirestore firestore;

  FirebaseIngredientRemoteDataSource({required this.firestore});

  @override
  Future<List<IngredientModel>> getIngredients() async {
    final QuerySnapshot meatSnapshot =
        await firestore.collection('meats').get();
    final QuerySnapshot vegetableSnapshot =
        await firestore.collection('vegetables').get();
    final QuerySnapshot carbSnapshot =
        await firestore.collection('carbs').get();

    final List<IngredientModel> ingredients = [];

    // Process meat ingredients
    for (var doc in meatSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      ingredients.add(IngredientModel.fromJson({
        'id': doc.id,
        'name': data['name'],
        'category': 'meat',
        'calories': data['calories'],
        'price': data['price'],
        'imageUrl': data['imageUrl'],
      }));
    }

    // Process vegetable ingredients
    for (var doc in vegetableSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      ingredients.add(IngredientModel.fromJson({
        'id': doc.id,
        'name': data['name'],
        'category': 'vegetable',
        'calories': data['calories'],
        'price': data['price'],
        'imageUrl': data['imageUrl'],
      }));
    }

    // Process carb ingredients
    for (var doc in carbSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      ingredients.add(IngredientModel.fromJson({
        'id': doc.id,
        'name': data['name'],
        'category': 'carb',
        'calories': data['calories'],
        'price': data['price'],
        'imageUrl': data['imageUrl'],
      }));
    }

    return ingredients;
  }
}
