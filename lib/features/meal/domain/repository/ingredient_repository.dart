import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:fpdart/fpdart.dart';

abstract class IngredientRepository {
  Future<Either<Failure, List<Ingredient>>> getIngredients();
}
