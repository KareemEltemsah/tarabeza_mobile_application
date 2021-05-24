import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_item.dart';

ValueNotifier<Order> currentOrder = new ValueNotifier(new Order());

addOrderItem(OrderItem orderItem) {
  if (!isSameRestaurant(orderItem.item.restaurant_id))
    clearOrderItems();
  if (currentOrder.value.orderItems.length == 0)
    currentOrder.value.restaurant_id = orderItem.item.restaurant_id;
  currentOrder.value.orderItems.add(orderItem);
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentOrder.notifyListeners();
}
bool isSameRestaurant(String id) {
  return currentOrder.value.restaurant_id == id ? true: false;
}
clearOrderItems() {
  currentOrder.value.orderItems.clear();
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentOrder.notifyListeners();
}