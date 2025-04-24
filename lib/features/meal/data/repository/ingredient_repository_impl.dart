import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/data/datasource/ingredient_remote_data_source.dart';
import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:assignment/features/meal/domain/repository/ingredient_repository.dart';
import 'package:fpdart/fpdart.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  final IngredientRemoteDataSource remoteDataSource;

  IngredientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Ingredient>>> getIngredients() async {
    try {
      final ingredients = await remoteDataSource.getIngredients();
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
