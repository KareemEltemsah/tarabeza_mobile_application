import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/filter.dart';
import '../models/restaurant.dart';

// import '../models/review.dart';
import '../repository/user_repository.dart';

/*Future<Stream<Restaurant>> getNearRestaurants(
    Address myLocation, Address areaLocation) async {
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '6';
  if (!myLocation.isUnknown() && !areaLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
    _queryParams['areaLon'] = areaLocation.longitude.toString();
    _queryParams['areaLat'] = areaLocation.latitude.toString();
  }
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(uri.toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getPopularRestaurants(Address myLocation) async {
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '6';
  _queryParams['popular'] = 'all';
  if (!myLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
  }
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(uri.toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}*/

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
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}
