part of 'ingredient_bloc.dart';

sealed class IngredientEvent extends Equatable {
  const IngredientEvent();

  @override
  List<Object> get props => [];
}

class LoadIngredientsEvent extends IngredientEvent {}
