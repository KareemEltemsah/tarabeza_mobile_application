import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import '../models/order_item.dart';

import '../models/order.dart';
import '../repository/order_repository.dart' as orderRepo;

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<bool> makeOrder () async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/make';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: json.encode(orderRepo.currentOrder.value.toMap()),
    );
    return (response.statusCode == 201) ? true : false;
  }
  removeFromOrder(OrderItem orderItem) {
    orderRepo.removeOrderItem(orderItem);
  }

  incrementQuantity(OrderItem orderItem) {
    if (orderItem.qty <= 99) orderItem.qty++;
    orderRepo.updateOrderListeners();
  }

  decrementQuantity(OrderItem orderItem) {
    if (orderItem.qty > 1) {
      orderItem.qty--;
      orderRepo.updateOrderListeners();
    } else
      removeFromOrder(orderItem);
  }


}
