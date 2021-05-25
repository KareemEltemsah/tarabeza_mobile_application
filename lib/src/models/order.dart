import '../models/user.dart';
import '../models/order_item.dart';

class Order {
  String id;
  String restaurant_id;
  List<OrderItem> orderItems;
  String orderStatus;
  double tax;
  String hint;
  bool active;
  DateTime dateTime;
  User user;

  Order() {
    orderItems = [];
  }

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      active = jsonMap['active'] ?? false;
      orderStatus = jsonMap['order_status'] ?? "";
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null
          ? User.fromJSON(jsonMap['user'])
          : User.fromJSON({});
    } catch (e) {
      id = '';
      tax = 0.0;
      hint = '';
      active = false;
      orderStatus = "";
      dateTime = DateTime(0);
      user = User.fromJSON({});
      orderItems = [];
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map["foods"] = orderItems?.map((element) => element.toMap())?.toList();
    return map;
  }

  double getTotalPrice() {
    double price = 0;
    orderItems.forEach((element) {
      price += element.getTotalPrice();
    });
    return price;
  }
}
