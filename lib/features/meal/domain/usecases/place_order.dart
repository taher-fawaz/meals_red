import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/order_item.dart';
import 'package:assignment/features/meal/domain/repository/order_repository.dart';
import 'package:fpdart/fpdart.dart';

class PlaceOrder {
  final OrderRepository repository;

  PlaceOrder(this.repository);

  Future<Either<Failure, bool>> call(List<OrderItem> items) async {
    return await repository.placeOrder(items);
  }
}
