import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/filter.dart';

Future<Stream<Category>> getCategories() async {
  Uri uri = Helper.getUri('restaurants/categories');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(uri.toString());
    return new Stream.value(new Category.fromJSON({}));
  }
}

// Future<Stream<Category>> getCategoriesOfRestaurant(String restaurantId) async {
//   Uri uri = Helper.getUri('api/categories');
//   Map<String, dynamic> _queryParams = {'restaurant_id': restaurantId};
//
//   uri = uri.replace(queryParameters: _queryParams);
//   try {
//     final client = new http.Client();
//     final streamedRest = await client.send(http.Request('get', uri));
//
//     return streamedRest.stream
//         .transform(utf8.decoder)
//         .transform(json.decoder)
//         .map((data) => Helper.getData(data))
//         .expand((data) => (data as List))
//         .map((data) => Category.fromJSON(data));
//   } catch (e) {
//     print(uri.toString());
//     return new Stream.value(new Category.fromJSON({}));
//   }
// }
