import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/OrderButtonWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ItemWidget.dart';

// import '../elements/SearchBarWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MenuWidget({Key key, this.parentScaffoldKey, this.routeArgument})
      : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  RestaurantController _con;
  List<String> selectedCategories;
  String searchWord = "";

  _MenuWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.restaurant = widget.routeArgument.param as Restaurant;
    _con.getRestaurantMenu();
    selectedCategories = ['0'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: Icon(Icons.close),
          color: Theme.of(context).hintColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _con.restaurant?.name ?? '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new OrderButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: _con.getRestaurantMenu,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              selectedCategories != ['0'] && _con.recommendedItems.isNotEmpty
                  ? Column(
                children: [
                  Center(
                    child: Text(
                      "Recommended items in selected category",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.recommendedItems.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ItemWidget(
                          heroTag: 'menu_list',
                          item: _con.recommendedItems.elementAt(index),
                          clickable: true,
                        ),
                      );
                    },
                  ),
                ],
              )
                  : SizedBox(height: 0),
              ListTile(
                dense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).all_menu,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              _con.categories.isEmpty
                  ? SizedBox(height: 0)
                  : Container(
                      height: 60,
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(_con.categories.length, (index) {
                          var _category = _con.categories.elementAt(index);
                          var _selected =
                              this.selectedCategories.contains(_category.id);
                          return Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 20),
                            child: RawChip(
                              elevation: 0,
                              label: Text(_category.name),
                              labelStyle: _selected
                                  ? Theme.of(context).textTheme.bodyText2.merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))
                                  : Theme.of(context).textTheme.bodyText2,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              backgroundColor:
                                  Theme.of(context).focusColor.withOpacity(0.1),
                              selectedColor: Theme.of(context).accentColor,
                              selected: _selected,
                              //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                              showCheckmark: false,
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    if (_category.id == '0')
                                      this.selectedCategories = ['0'];
                                    else {
                                      this.selectedCategories.add(_category.id);
                                      if (selectedCategories.contains('0'))
                                        this.selectedCategories.removeWhere(
                                            (element) => element == '0');
                                    }
                                  } else {
                                    if (_category.id != '0')
                                      this.selectedCategories.removeWhere(
                                          (element) => element == _category.id);
                                    if (selectedCategories.length == 0)
                                      this.selectedCategories = ['0'];
                                  }
                                  _con.selectCategory(this.selectedCategories);
                                  _con.selectByName(searchWord);
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      searchWord = text;
                      _con.selectCategory(this.selectedCategories);
                      _con.selectByName(searchWord);
                    });
                  },
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 48, 12),
                    hintText: S.of(context).search_by_name,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .merge(TextStyle(fontSize: 14)),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).accentColor),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.1))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.3))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.1))),
                  ),
                ),
              ),
              _con.selectedItems.isEmpty
                  ? Center(
                      child: Text(
                        "No Results",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.selectedItems.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ItemWidget(
                            heroTag: 'menu_list',
                            item: _con.selectedItems.elementAt(index),
                            clickable: true,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
