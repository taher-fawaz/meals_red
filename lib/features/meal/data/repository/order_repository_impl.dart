import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/data/datasource/order_remote_data_source.dart';
import 'package:assignment/features/meal/data/model/order_model.dart';
import 'package:assignment/features/meal/domain/entites/order_item.dart';
import 'package:assignment/features/meal/domain/repository/order_repository.dart';
import 'package:fpdart/fpdart.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> placeOrder(List<OrderItem> items) async {
    try {
      final itemModels = items
          .map((item) => OrderItemModel(
                ingredient: item.ingredient,
                quantity: item.quantity,
              ))
          .toList();
      final result = await remoteDataSource.placeOrder(itemModels);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
