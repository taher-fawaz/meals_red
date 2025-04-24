import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:assignment/features/meal/domain/repository/ingredient_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetIngredients {
  final IngredientRepository repository;

  GetIngredients(this.repository);

  Future<Either<Failure, List<Ingredient>>> call() async {
    return await repository.getIngredients();
  }
}
