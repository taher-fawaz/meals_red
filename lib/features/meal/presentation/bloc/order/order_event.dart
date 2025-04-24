part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddIngredientEvent extends OrderEvent {
  final Ingredient ingredient;

  const AddIngredientEvent(this.ingredient);

  @override
  List<Object> get props => [ingredient];
}

class RemoveIngredientEvent extends OrderEvent {
  final Ingredient ingredient;

  const RemoveIngredientEvent(this.ingredient);

  @override
  List<Object> get props => [ingredient];
}

class PlaceOrderEvent extends OrderEvent {}

class ResetOrderEvent extends OrderEvent {}
