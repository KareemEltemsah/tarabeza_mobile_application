import 'dart:convert';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/restaurant.dart';
import '../repository/restaurant_repository.dart';
import '../repository/search_repository.dart';

class SearchController extends ControllerMVC {
  List<Restaurant> restaurants = <Restaurant>[];

  SearchController() {
    listenForRestaurants();
  }

  void listenForRestaurants({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    search = search.trim();
    if (search != "") {
      final Stream<Restaurant> stream = await searchRestaurants(search);
      stream.listen((Restaurant _restaurant) {
        setState(() => restaurants.add(_restaurant));
        print(_restaurant.toMap());
      }, onError: (e) {
        print(e);
      }, onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('recent_search_result',
          json.encode(restaurants.map((r) => r.toMap()).toList()));});
    }
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      restaurants = <Restaurant>[];
    });
    listenForRestaurants(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
