import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';

import '../elements/PermissionDeniedWidget.dart';
import 'restaurant.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

// import 'map.dart';
import 'menu_list.dart';
import 'reviews.dart';
import '../models/restaurant.dart';

class DetailsWidget extends StatefulWidget {
  RouteArgument routeArgument;
  dynamic currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage;

  DetailsWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  RestaurantController _con;

  _DetailsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  initState() {
    _selectTab(widget.currentTab);
    super.initState();
  }

  @override
  void didUpdateWidget(DetailsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          _con.getRestaurant("27" /*widget.routeArgument.param*/).then((value) {
            print("rest map");
            print(_con.restaurant.toMap());
            print("items map ${_con.items.length}");
            print("categories map ${_con.categories.length}");

            widget.currentPage = RestaurantWidget(
                parentScaffoldKey: widget.scaffoldKey,
                routeArgument: RouteArgument(param: _con.restaurant));
          });
          break;
        case 1:
          widget.currentPage = ReviewsWidget(
              parentScaffoldKey: widget.scaffoldKey,
              routeArgument: RouteArgument(param: _con.restaurant));
          break;
        case 2:
          widget.currentPage = MenuWidget(
              parentScaffoldKey: widget.scaffoldKey,
              routeArgument: RouteArgument(param: _con.restaurant));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        bottomNavigationBar: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.10),
                  offset: Offset(0, -4),
                  blurRadius: 10)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.store,
                  size: widget.currentTab == 0 ? 28 : 24,
                  color: widget.currentTab == 0
                      ? Theme.of(context).accentColor
                      : Theme.of(context).focusColor,
                ),
                onPressed: () {
                  this._selectTab(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.rate_review_rounded,
                  size: widget.currentTab == 1 ? 28 : 24,
                  color: widget.currentTab == 1
                      ? Theme.of(context).accentColor
                      : Theme.of(context).focusColor,
                ),
                onPressed: () {
                  this._selectTab(1);
                },
              ),
              FlatButton(
                onPressed: () {
                  this._selectTab(2);
                },
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: StadiumBorder(),
                color: Theme.of(context).accentColor,
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(Icons.restaurant,
                        color: Theme.of(context).primaryColor),
                    Text(
                      S.of(context).menu,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: widget.currentPage ?? CircularLoadingWidget(height: 400));
  }
}
