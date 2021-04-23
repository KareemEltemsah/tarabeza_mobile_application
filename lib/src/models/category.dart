class Category {
  String id;
  String name;

  bool selected = false;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      selected = jsonMap['selected'] ?? false;
    } catch (e) {
      id = '';
      name = '';
      selected = false;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    // map['selected'] = selected;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
