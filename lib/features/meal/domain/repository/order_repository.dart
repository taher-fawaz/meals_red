import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/features/meal/domain/entites/order_item.dart';
import 'package:fpdart/fpdart.dart';

abstract class OrderRepository {
  Future<Either<Failure, bool>> placeOrder(List<OrderItem> items);
}
