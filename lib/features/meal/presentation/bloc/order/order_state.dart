part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderInProgress extends OrderState {
  final List<OrderItem> items;
  final double totalCalories;
  final double targetCalories;
  final bool canPlaceOrder;

  const OrderInProgress({
    required this.items,
    required this.totalCalories,
    required this.targetCalories,
    required this.canPlaceOrder,
  });

  @override
  List<Object> get props =>
      [items, totalCalories, targetCalories, canPlaceOrder];

  OrderInProgress copyWith({
    List<OrderItem>? items,
    double? totalCalories,
    double? targetCalories,
    bool? canPlaceOrder,
  }) {
    return OrderInProgress(
      items: items ?? this.items,
      totalCalories: totalCalories ?? this.totalCalories,
      targetCalories: targetCalories ?? this.targetCalories,
      canPlaceOrder: canPlaceOrder ?? this.canPlaceOrder,
    );
  }
}

class OrderSuccess extends OrderState {}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
