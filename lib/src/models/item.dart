class Item {
  String id;
  String restaurant_id;
  String category_id;
  String name;
  String description;
  double price;
  double discount;
  String image;
  bool is_available;
  String category_name;

  String count_orders;

  Item();

  Item.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      restaurant_id = jsonMap['restaurant_id'].toString();
      category_id = jsonMap['category_id'].toString();
      name = jsonMap['name'];
      description = jsonMap['description'].toString() ?? '';
      price = jsonMap['price'] != null
          ? double.parse(jsonMap['price'].toString())
          : 0.0;
      discount = jsonMap['discount'] != null
          ? double.parse(jsonMap['discount'].toString())
          : 0.0;
      image = jsonMap['image'].toString() ?? '';
      is_available = jsonMap['is_available'].toString() == '1' ? true : false;
      category_name = jsonMap['category_name'] ?? '';
    } catch (e) {
      id = '';
      restaurant_id = '';
      category_id = '';
      name = '';
      description = '';
      price = 0.0;
      discount = 0.0;
      image = '';
      is_available = false;
      category_name = '';
      print(e);
    }
  }

  Item.AsTopItemFromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['item_id'].toString();
    name = jsonMap['item_name'];
    count_orders = jsonMap['count_orders'].toString();
  }

  Map toMap() {
    return {
      "id": id,
      "restaurant_id": restaurant_id,
      "category_id": category_id,
      "name": name,
      "description": description,
      "price": price.toString(),
      "discount": discount.toString(),
      "image": image,
      "is_available": is_available ? '1' : '0',
      "category_name": category_name
    };
  }

  Map toMapAsTopItem() {
    return {"id": id, "name": name, "count": count_orders};
  }

  double getPrice() {
    return discount > 0 ? (price - price * discount) : price;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
