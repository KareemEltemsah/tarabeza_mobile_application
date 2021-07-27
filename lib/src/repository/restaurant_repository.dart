import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/helper.dart';
import '../models/filter.dart';
import '../models/restaurant.dart';

// ignore: missing_return
Future<Stream<Restaurant>> searchRestaurants(String search) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  Uri uri = Helper.getUri('search');
  Map<String, dynamic> _queryParams = {};
  _queryParams['restaurant_name'] = '${search}';
  _queryParams['categories'] =
      '${filter.categories.length > 0 ? filter.toString() : prefs.getString('allCategories')}';
  uri = uri.replace(queryParameters: _queryParams);
  print("search uri\n${uri.toString()}\nend");
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((response) => Helper.getData(response))
        .expand((data) => (data as List))
        .map((restaurantData) {
      return Restaurant.fromJSON(restaurantData);
    });
  } catch (e) {
    print(uri.toString());
  }
}
