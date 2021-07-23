import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/order_item.dart';

import '../models/order.dart';
import '../repository/order_repository.dart' as orderRepo;

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
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
