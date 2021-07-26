import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import '../models/order_item.dart';

import '../models/order.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/user_repository.dart' as userRepo;

class OrderController extends ControllerMVC {
  ValueNotifier<List<Order>> orders = ValueNotifier(<Order>[]);
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<bool> makeOrder() async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/make';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: json.encode(orderRepo.currentOrder.value.toMap()),
    );
    if (userRepo.currentUser.value.role == "customer") {
      List<String> categoriesIDs = new List<String>();
      orderRepo.currentOrder.value.orderItems.forEach((element) {
        !categoriesIDs.contains(element.item.category_id)
            ? categoriesIDs.add(element.item.category_id)
            : null;
      });
      addPrefs(categoriesIDs);
    }
    orderRepo.clearOrderItems();
    return (response.statusCode == 201) ? true : false;
  }

  Future<void> addPrefs(List<String> IDs) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}cust/pref/add';
    final client = new http.Client();
    IDs.forEach((element) async {
      await client.post(
        url,
        body: json.encode({
          "customer_id": "${userRepo.currentUser.value.customer_id}",
          "category_id": "${element}"
        }),
      );
    });
  }

  Future<void> getUserOrders() async {
    orders.value.clear();
    final String url = '${GlobalConfiguration().getValue('api_base_url')}'
        'orders/cust_not_finished/${userRepo.currentUser.value.customer_id}';
    final client = new http.Client();
    final ordersResponse = await client.get(url);
    // print(ordersResponse.body);
    setState(() {
      (jsonDecode(ordersResponse.body)["data"] as List).forEach((element) {
        if (orderIDs().contains(element["id"])) {
          orders.value
              .elementAt(orders.value.indexWhere((o) => o.id == element["id"]))
              .orderItems
              .add(new OrderItem.fromJSON(element));
        } else
          orders.value.add(new Order.fromJSON(element));
      });
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      orders.notifyListeners();
    });
  }

  List<String> orderIDs() {
    return orders.value.map((e) => e.id).toList();
  }

  Future<void> getRestaurantOrders() async {
    orders.value.clear();
    final String url = '${GlobalConfiguration().getValue('api_base_url')}'
        'orders/rest_not_finished/${userRepo.currentUser.value.restaurant_id}';
    final client = new http.Client();
    final ordersResponse = await client.get(url);
    // print(ordersResponse.body);
    setState(() {
      (jsonDecode(ordersResponse.body)["data"] as List).forEach((element) {
        if (orderIDs().contains(element["id"])) {
          orders.value
              .elementAt(orders.value.indexWhere((o) => o.id == element["id"]))
              .orderItems
              .add(new OrderItem.fromJSON(element));
        } else
          orders.value.add(new Order.fromJSON(element));
      });
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      orders.notifyListeners();
    });
  }

  Future<void> cancelOrder(Order order) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/cancel';
    final client = new http.Client();
    final cancelResponse =
        await client.post(url, body: json.encode(order.idToMap()));
    print(cancelResponse.body);
    userRepo.currentUser.value.role == "staff"
        ? getRestaurantOrders()
        : getUserOrders();
  }

  Future<void> approveOrder(Order order) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/approve';
    final client = new http.Client();
    final approveResponse =
        await client.post(url, body: json.encode(order.idToMap()));
    print(approveResponse.body);
    userRepo.currentUser.value.role == "staff"
        ? getRestaurantOrders()
        : getUserOrders();
  }

  Future<void> finishOrder(Order order) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/finish';
    final client = new http.Client();
    final finishResponse =
        await client.post(url, body: json.encode(order.idToMap()));
    print(finishResponse.body);
    userRepo.currentUser.value.role == "staff"
        ? getRestaurantOrders()
        : getUserOrders();
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
