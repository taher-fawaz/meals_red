import 'package:assignment/core/utils/failure_converter.dart';
import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:assignment/features/meal/domain/entites/order_item.dart';
import 'package:assignment/features/meal/domain/usecases/place_order.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrder placeOrder;
  final double targetCalories;

  OrderBloc({
    required this.placeOrder,
    required this.targetCalories,
  }) : super(OrderInitial()) {
    on<AddIngredientEvent>(_onAddIngredient);
    on<RemoveIngredientEvent>(_onRemoveIngredient);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<ResetOrderEvent>(_onResetOrder);
  }

  void _onAddIngredient(
    AddIngredientEvent event,
    Emitter<OrderState> emit,
  ) {
    final currentState = state;
    if (currentState is OrderInProgress) {
      // Check if ingredient already exists in the order
      final existingItemIndex = currentState.items.indexWhere(
        (item) => item.ingredient.id == event.ingredient.id,
      );

      List<OrderItem> updatedItems = List.from(currentState.items);

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = currentState.items[existingItemIndex];
        updatedItems[existingItemIndex] = OrderItem(
          ingredient: existingItem.ingredient,
          quantity: existingItem.quantity + 1,
        );
      } else {
        // Add new item
        updatedItems.add(OrderItem(
          ingredient: event.ingredient,
          quantity: 1,
        ));
      }

      final totalCalories = _calculateTotalCalories(updatedItems);
      final canPlaceOrder =
          _canPlaceOrder(totalCalories, currentState.targetCalories);

      emit(currentState.copyWith(
        items: updatedItems,
        totalCalories: totalCalories,
        canPlaceOrder: canPlaceOrder,
      ));
    } else {
      final items = [OrderItem(ingredient: event.ingredient, quantity: 1)];
      final totalCalories = _calculateTotalCalories(items);
      final canPlaceOrder = _canPlaceOrder(totalCalories, targetCalories);

      emit(OrderInProgress(
        items: items,
        totalCalories: totalCalories,
        targetCalories: targetCalories,
        canPlaceOrder: canPlaceOrder,
      ));
    }
  }

  void _onRemoveIngredient(
    RemoveIngredientEvent event,
    Emitter<OrderState> emit,
  ) {
    final currentState = state;
    if (currentState is OrderInProgress) {
      final existingItemIndex = currentState.items.indexWhere(
        (item) => item.ingredient.id == event.ingredient.id,
      );

      if (existingItemIndex != -1) {
        final existingItem = currentState.items[existingItemIndex];
        List<OrderItem> updatedItems = List.from(currentState.items);

        if (existingItem.quantity > 1) {
          // Decrease quantity
          updatedItems[existingItemIndex] = OrderItem(
            ingredient: existingItem.ingredient,
            quantity: existingItem.quantity - 1,
          );
        } else {
          // Remove item
          updatedItems.removeAt(existingItemIndex);
        }

        if (updatedItems.isEmpty) {
          emit(OrderInitial());
        } else {
          final totalCalories = _calculateTotalCalories(updatedItems);
          final canPlaceOrder =
              _canPlaceOrder(totalCalories, currentState.targetCalories);

          emit(currentState.copyWith(
            items: updatedItems,
            totalCalories: totalCalories,
            canPlaceOrder: canPlaceOrder,
          ));
        }
      }
    }
  }

  void _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    final currentState = state;
    if (currentState is OrderInProgress && currentState.canPlaceOrder) {
      emit(OrderLoading());
      final result = await placeOrder(currentState.items);
      result.fold(
        (failure) => emit(OrderError(mapFailureToMessage(failure))),
        (success) => emit(OrderSuccess()),
      );
    }
  }

  void _onResetOrder(
    ResetOrderEvent event,
    Emitter<OrderState> emit,
  ) {
    emit(OrderInitial());
  }

  double _calculateTotalCalories(List<OrderItem> items) {
    return items.fold(
        0, (sum, item) => sum + (item.quantity * item.ingredient.calories));
  }

  bool _canPlaceOrder(double totalCalories, double targetCalories) {
    // Within 10% under or over target
    final lowerBound = targetCalories * 0.9;
    final upperBound = targetCalories * 1.1;
    return totalCalories >= lowerBound && totalCalories <= upperBound;
  }
}
