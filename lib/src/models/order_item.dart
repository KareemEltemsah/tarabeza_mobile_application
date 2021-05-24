import '../models/item.dart';

class OrderItem {
  Item item;
  int quantity;
  double totalPrice;
  OrderItem(Item i, int q) {
    item = i;
    quantity = q;
    totalPrice = item.getPrice() * quantity;
  }

  OrderItem.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      /*price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;*/
    } catch (e) {
      /*price = 0.0;
      quantity = 0.0;
      item = item.fromJSON({});*/
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    /*map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;*/
    return map;
  }
}
