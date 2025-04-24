import 'package:assignment/features/meal/presentation/widgets/ingredient_counter_widget.dart';
import 'package:assignment/features/meal/presentation/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/themes/app_color.dart';
import '../../../../core/themes/app_font.dart';
import '../../../../routes/app_route_path.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/leading_back_button_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../bloc/ingredient/ingredient_bloc.dart';
import '../../domain/entites/ingredient.dart';
import '../../domain/entites/order_item.dart';

class PlaceOrderPage extends StatefulWidget {
  final Map<String, dynamic> args;

  const PlaceOrderPage({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage>
    with SingleTickerProviderStateMixin {
  late final double _tdee;
  late final String _userName;
  final List<OrderItem> _selectedItems = [];
  double _currentCalories = 0;
  late TabController _tabController;

  // Current view mode (ingredients list or cart)
  bool _showingCart = false;

  @override
  void initState() {
    super.initState();
    _tdee = widget.args['tdee'] as double;
    _userName = widget.args['name'] as String;
    _tabController = TabController(length: 3, vsync: this);

    // Load ingredients when page is opened
    BlocProvider.of<IngredientBloc>(context).add(LoadIngredientsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create your order', style: AppFont.subtitle),
        leading: const LeadingBackButtonWidget(),
        elevation: 0,
        actions: [
          // Cart button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_selectedItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _selectedItems.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _showingCart = !_showingCart;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User info and calorie counter
          _buildUserInfoHeader(),

          // Toggle between ingredients list and cart
          if (_showingCart)
            _buildCartView()
          else
            // Ingredients categories with tab view
            Expanded(
              child: BlocBuilder<IngredientBloc, IngredientState>(
                builder: (context, state) {
                  if (state is IngredientLoading) {
                    return const LoadingWidget();
                  } else if (state is IngredientLoaded) {
                    return _buildCategorizedIngredients(state.ingredients);
                  } else if (state is IngredientError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(
                      child: Text('No ingredients available'),
                    );
                  }
                },
              ),
            ),

          // Bottom summary bar
          _buildBottomSummaryBar(),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColor.secondaryBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User greeting
          Text(
            'Hello, $_userName',
            style: AppFont.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Calorie target
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Target calories: ',
                  style: AppFont.body.copyWith(color: AppColor.textSecondary),
                ),
                TextSpan(
                  text: '${_tdee.toStringAsFixed(0)} Cal',
                  style: AppFont.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          CalorieProgressIndicatorWidget(
            targetCalories: _tdee,
            currentCalories: _currentCalories,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorizedIngredients(List<Ingredient> ingredients) {
    return Column(
      children: [
        // Tab bar
        Container(
          color: AppColor.primary,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Meats'),
              Tab(text: 'Vegetables'),
              Tab(text: 'Carbs'),
            ],
          ),
        ),

        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Meats tab
              _buildIngredientsGrid(
                  ingredients.where((i) => i.category == 'meat').toList()),

              // Vegetables tab
              _buildIngredientsGrid(
                  ingredients.where((i) => i.category == 'vegetable').toList()),

              // Carbs tab
              _buildIngredientsGrid(
                  ingredients.where((i) => i.category == 'carb').toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsGrid(List<Ingredient> ingredients) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];

        // Check if ingredient is already in cart
        final existingItem = _selectedItems.firstWhere(
          (item) => item.ingredient.id == ingredient.id,
          orElse: () => OrderItem(ingredient: ingredient, quantity: 0),
        );

        if (existingItem.quantity > 0) {
          // Show counter version if already in cart
          return _buildIngredientCardWithCounter(
              ingredient, existingItem.quantity);
        } else {
          // Show add button version
          return _buildIngredientCard(ingredient);
        }
      },
    );
  }

  Widget _buildIngredientCard(Ingredient ingredient) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: NetworkImage(ingredient.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ingredient name
                  Text(
                    ingredient.name,
                    style: AppFont.body.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Calories
                  Text(
                    '${ingredient.calories.toStringAsFixed(0)} Cal',
                    style: AppFont.caption,
                  ),

                  // Price and add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${ingredient.price.toStringAsFixed(0)}',
                        style:
                            AppFont.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => _addIngredient(ingredient),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCardWithCounter(Ingredient ingredient, int quantity) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: NetworkImage(ingredient.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ingredient name
                  Text(
                    ingredient.name,
                    style: AppFont.body.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Calories
                  Text(
                    '${ingredient.calories.toStringAsFixed(0)} Cal',
                    style: AppFont.caption,
                  ),

                  // Price and counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${ingredient.price.toStringAsFixed(0)}',
                        style:
                            AppFont.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Decrease button
                          GestureDetector(
                            onTap: () => _removeIngredient(ingredient),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColor.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),

                          // Quantity
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              quantity.toString(),
                              style: AppFont.body
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),

                          // Increase button
                          GestureDetector(
                            onTap: () => _addIngredient(ingredient),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColor.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartView() {
    if (_selectedItems.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('Your cart is empty'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _selectedItems.length,
        itemBuilder: (context, index) {
          final item = _selectedItems[index];
          return IngredientCounterWidget(
            ingredient: item.ingredient,
            quantity: item.quantity,
            price: item.ingredient.price * item.quantity,
            onIncrease: () => _addIngredient(item.ingredient),
            onDecrease: () => _removeIngredient(item.ingredient),
          );
        },
      ),
    );
  }

  Widget _buildBottomSummaryBar() {
    final bool canPlaceOrder = _isWithinCalorieRange();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Calories
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cal',
                    style: AppFont.caption,
                  ),
                  Text(
                    '${_currentCalories.toStringAsFixed(0)} Cal out of ${_tdee.toStringAsFixed(0)} Cal',
                    style: AppFont.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Price',
                    style: AppFont.caption,
                  ),
                  Text(
                    '\$${_calculateTotalPrice().toStringAsFixed(0)}',
                    style: AppFont.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Place order button
          AppButtonWidget(
            label: 'Place order',
            callback: () {
              if (canPlaceOrder) {
                context.pushNamed(
                  AppRoute.orderSummary.name,
                  extra: {
                    'items': _selectedItems,
                    'totalCalories': _currentCalories,
                    'targetCalories': _tdee,
                    'totalPrice': _calculateTotalPrice(),
                  },
                );
              }
            },
            isDisabled: !canPlaceOrder,
            paddingVertical: 16,
          ),
        ],
      ),
    );
  }

  void _addIngredient(Ingredient ingredient) {
    setState(() {
      // Check if the ingredient is already in the order
      final existingItemIndex = _selectedItems.indexWhere(
        (item) => item.ingredient.id == ingredient.id,
      );

      if (existingItemIndex != -1) {
        // Increase quantity if already in order
        _selectedItems[existingItemIndex] = OrderItem(
          ingredient: ingredient,
          quantity: _selectedItems[existingItemIndex].quantity + 1,
        );
      } else {
        // Add new item if not already in order
        _selectedItems.add(OrderItem(
          ingredient: ingredient,
          quantity: 1,
        ));
      }

      // Recalculate calories
      _updateCurrentCalories();
    });
  }

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      // Find the ingredient in the order
      final existingItemIndex = _selectedItems.indexWhere(
        (item) => item.ingredient.id == ingredient.id,
      );

      if (existingItemIndex != -1) {
        final currentQuantity = _selectedItems[existingItemIndex].quantity;

        if (currentQuantity > 1) {
          // Decrease quantity
          _selectedItems[existingItemIndex] = OrderItem(
            ingredient: ingredient,
            quantity: currentQuantity - 1,
          );
        } else {
          // Remove item completely
          _selectedItems.removeAt(existingItemIndex);
        }

        // Recalculate calories
        _updateCurrentCalories();
      }
    });
  }

  void _updateCurrentCalories() {
    _currentCalories = _selectedItems.fold(
      0,
      (total, item) => total + (item.ingredient.calories * item.quantity),
    );
  }

  double _calculateTotalPrice() {
    return _selectedItems.fold(
      0,
      (total, item) => total + (item.ingredient.price * item.quantity),
    );
  }

  bool _isWithinCalorieRange() {
    // Check if calories are within 10% of target
    final lowerBound = _tdee * 0.9;
    final upperBound = _tdee * 1.1;
    return _currentCalories >= lowerBound &&
        _currentCalories <= upperBound &&
        _selectedItems.isNotEmpty;
  }
}
