import 'package:assignment/core/utils/failure_converter.dart';
import 'package:assignment/features/meal/domain/entites/ingredient.dart';
import 'package:assignment/features/meal/domain/usecases/get_ingredients.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ingredient_event.dart';
part 'ingredient_state.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final GetIngredients getIngredients;

  IngredientBloc({required this.getIngredients}) : super(IngredientInitial()) {
    on<LoadIngredientsEvent>(_onLoadIngredients);
  }

  void _onLoadIngredients(
    LoadIngredientsEvent event,
    Emitter<IngredientState> emit,
  ) async {
    emit(IngredientLoading());
    final result = await getIngredients();
    result.fold(
      (failure) => emit(IngredientError(mapFailureToMessage(failure))),
      (ingredients) => emit(IngredientLoaded(ingredients)),
    );
  }
}
