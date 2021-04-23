// import '../helpers/custom_trace.dart';
import '../models/category.dart';

class Filter {
  List<Category> categories;

  Filter();

  Filter.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      categories = jsonMap['categories'] != null &&
              (jsonMap['categories'] as List).length > 0
          ? List.from(jsonMap['categories'])
              .map((element) => Category.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['categories'] = categories.map((element) => element.toMap()).toList();
    return map;
  }

  @override
  String toString() {
    String filter = "";
    if (categories.length > 0) {
      categories.forEach((_category) {
        filter += '${_category.name},';
      });
      filter.endsWith(',')
          ? filter = filter.substring(0, filter.lastIndexOf(','))
          : null;
    }
    return filter;
  }
}
