import 'dart:convert';

import 'package:assignment/core/api/api_helper.dart';
import 'package:assignment/features/meal/data/model/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<bool> placeOrder(List<OrderItemModel> items);
}

class ApiOrderRemoteDataSource implements OrderRemoteDataSource {
  final ApiHelper client;

  ApiOrderRemoteDataSource({required this.client});

  @override
  Future<bool> placeOrder(List<OrderItemModel> items) async {
    final response = await client.execute(
      method: Method.post,
      data: {
        'items': items.map((item) => item.toJson()).toList(),
      },
      url: '/order',
    );
    if (response != null) {
      throw Exception('Failed to place order: ${response}');
    }

    return true;
  }
}
