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

  Item();

  Item.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      restaurant_id = jsonMap['restaurant_id'];
      category_id = jsonMap['category_id'];
      name = jsonMap['name'];
      description = jsonMap['description'] ?? '';
      price = jsonMap['price'] != null ? double.parse(jsonMap['price']) : 0.0;
      discount =
          jsonMap['discount'] != null ? double.parse(jsonMap['discount']) : 0.0;
      image = jsonMap['media'] ?? '';
      is_available = jsonMap['is_available'] == '1' ? true : false;
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
