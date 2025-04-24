import 'package:assignment/core/themes/app_color.dart';
import 'package:assignment/core/themes/app_font.dart';
import 'package:assignment/routes/app_route_path.dart';
import 'package:assignment/widgets/button_widget.dart';
import 'package:assignment/widgets/leading_back_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entites/order_item.dart';
import '../widgets/simplified_ingredient_counter.dart';

class OrderSummaryPage extends StatefulWidget {
  final Map<String, dynamic> args;

  const OrderSummaryPage({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late List<OrderItem> _items;
  late double _totalCalories;
  late double _targetCalories;
  late double _totalPrice;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _items = widget.args['items'] as List<OrderItem>;
    _totalCalories = widget.args['totalCalories'] as double;
    _targetCalories = widget.args['targetCalories'] as double;
    _totalPrice = widget.args['totalPrice'] as double;
  }

  void _updateOrderItem(OrderItem oldItem, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        // Remove item
        _items
            .removeWhere((item) => item.ingredient.id == oldItem.ingredient.id);
      } else {
        // Update quantity
        final index = _items
            .indexWhere((item) => item.ingredient.id == oldItem.ingredient.id);
        if (index != -1) {
          _items[index] = OrderItem(
            ingredient: oldItem.ingredient,
            quantity: newQuantity,
          );
        }
      }

      // Recalculate totals
      _recalculateTotals();
    });
  }

  void _recalculateTotals() {
    _totalCalories = _items.fold(
      0,
      (total, item) => total + (item.ingredient.calories * item.quantity),
    );

    _totalPrice = _items.fold(
      0,
      (total, item) => total + (item.ingredient.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order summary', style: AppFont.subtitle),
        leading: const LeadingBackButtonWidget(),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Items list
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return SimpleIngredientCounterWidget(
                        ingredient: item.ingredient,
                        quantity: item.quantity,
                        price: item.ingredient.price * item.quantity,
                        onIncrease: () =>
                            _updateOrderItem(item, item.quantity + 1),
                        onDecrease: () =>
                            _updateOrderItem(item, item.quantity - 1),
                      );
                    },
                  ),
          ),

          // Bottom summary and confirm button
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    // Check if order can still be placed
    final bool canPlaceOrder = _isWithinCalorieRange() && _items.isNotEmpty;

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
          // Summary info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Calories
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cals',
                    style: AppFont.caption,
                  ),
                  Text(
                    '${_totalCalories.toStringAsFixed(0)} Cal out of ${_targetCalories.toStringAsFixed(0)} Cal',
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
                    '\$${_totalPrice.toStringAsFixed(0)}',
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

          // Confirm button
          AppButtonWidget(
            label: 'Confirm',
            callback: canPlaceOrder ? () => _placeOrder() : null,
            isDisabled: !canPlaceOrder || _isLoading,
            isLoading: _isLoading,
            paddingVertical: 16,
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: AppColor.error,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColor.success,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Order Placed',
              style: AppFont.subtitle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Your order has been successfully placed. You will be redirected to home.',
          style: AppFont.body,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(AppRoute.home.name);
            },
            child: Text(
              'OK',
              style: AppFont.subtitle.copyWith(color: AppColor.primary),
            ),
          ),
        ],
      ),
    );
  }

  bool _isWithinCalorieRange() {
    // Check if calories are within 10% of target
    final lowerBound = _targetCalories * 0.9;
    final upperBound = _targetCalories * 1.1;
    return _totalCalories >= lowerBound && _totalCalories <= upperBound;
  }
}
