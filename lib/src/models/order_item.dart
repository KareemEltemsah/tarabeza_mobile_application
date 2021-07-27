import '../models/item.dart';

class OrderItem {
  String id;
  String item_name;
  int qty;
  double total;

  Item item;

  OrderItem(Item i, int q, this.id) {
    item = i;
    qty = q;
  }

  OrderItem.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      item_name = jsonMap["item_name"];
      qty = int.parse(jsonMap["qty"]);
      total = double.parse(jsonMap["total"]);
    } catch (e) {
      print(e);
    }
  }

  double getTotalPrice() {
    return item.getPrice() * qty;
  }

  bool operator ==(dynamic other) {
    return other.item == this.item;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["meal_id"] = item.id;
    map["quantity"] = qty;
    map["comment"] = "";
    map["total"] = getTotalPrice();
    return map;
  }
}
