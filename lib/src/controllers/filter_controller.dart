import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';

import '../models/category.dart';
import '../models/filter.dart';
import '../repository/category_repository.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class FilterController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Category> categories = [];
  Filter filter;

  FilterController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFilter().whenComplete(() {
      listenForCategories();
    });
  }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    });
    // print("filter as String\n${filter.toString()}\nfilter end");
    // print(filter.toMap());
  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filter.categories =
        this.categories.where((_f) => _f.selected && _f.id != "0").toList();
    prefs.setString('filter', json.encode(filter.toMap()));
  }

  void listenForCategories({String message}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('categories') && prefs.containsKey('allCategories') && settingsRepo.useCaching.value) {
      print('category from prefs');
      List _categories = json.decode(await prefs.getString('categories'));
      _categories.forEach((element) {
        Category _c = Category.fromJSON(element);
        if (filter.categories.contains(_c)) {
          _c.selected = true;
          categories.elementAt(0).selected = false;
        }
        if (_c.id == "0") _c.selected = true;
        categories.add(_c);
      });
    } else {
      String allCategories = '';
      categories.add(new Category.fromJSON(
          {'id': '0', 'name': S.of(context).all, 'selected': true}));
      final Stream<Category> stream = await getCategories();
      stream.listen((Category _category) {
        setState(() {
          if (filter.categories.contains(_category)) {
            _category.selected = true;
            categories.elementAt(0).selected = false;
          }
          categories.add(_category);
          allCategories += _category.name + ',';
        });
      }, onError: (a) {
        print(a);
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).verify_your_internet_connection),
        ));
      }, onDone: () async {
        allCategories =
            allCategories.substring(0, allCategories.lastIndexOf(','));
        // print("allCategories\n${allCategories}\nall ends");
        prefs.setString('categories',
            json.encode(categories.map((e) => e.toMap()).toList()));
        prefs.setString('allCategories', allCategories);
        print("categories saved");
      });
    }
  }

  Future<void> refreshCategories() async {
    categories.clear();
    listenForCategories();
  }

  void clearFilter() {
    setState(() {
      resetCategories();
    });
  }

  void resetCategories() {
    filter.categories = [];
    categories.forEach((Category _f) {
      _f.selected = false;
    });
    categories.elementAt(0).selected = true;
  }

  void onChangeCategoriesFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetCategories();
      });
    } else {
      setState(() {
        categories.elementAt(index).selected =
            !categories.elementAt(index).selected;
        categories.elementAt(0).selected = false;
        bool empty = true;
        categories.forEach((element) {if (element.selected) empty = false;});
        empty ? categories.elementAt(0).selected = true : null;
      });
    }
  }
}
