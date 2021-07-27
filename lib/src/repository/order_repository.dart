import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import 'user_repository.dart' as userRepo;

ValueNotifier<Order> currentOrder = new ValueNotifier(new Order());

addOrderItem(OrderItem orderItem) {
  //checking if the same restaurant
  if (!isSameRestaurant(orderItem.item.restaurant_id)) clearOrderItems();
  //set restaurant id
  if (currentOrder.value.orderItems.length == 0) {
    userRepo.currentUser.value.role == 'customer'
        ? currentOrder.value.customer_id =
            userRepo.currentUser.value.customer_id
        : currentOrder.value.customer_id = '242';
    currentOrder.value.restaurant_id = orderItem.item.restaurant_id;
  }
  //update quantity if the item already exist
  if (currentOrder.value.orderItems.contains(orderItem)) {
    int index = currentOrder.value.orderItems
        .indexWhere((element) => element == orderItem);
    currentOrder.value.orderItems.elementAt(index).qty += orderItem.qty;
  } else //add new item
    currentOrder.value.orderItems.add(orderItem);
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentOrder.notifyListeners();
}

bool isSameRestaurant(String id) {
  return currentOrder.value.restaurant_id == id ? true : false;
}

clearOrderItems() {
  currentOrder.value.orderItems.clear();
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentOrder.notifyListeners();
}

updateOrderListeners() {
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentOrder.notifyListeners();
}

removeOrderItem(OrderItem orderItem) {
  currentOrder.value.orderItems.removeWhere((element) => element == orderItem);
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentOrder.notifyListeners();
}
