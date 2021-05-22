import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ItemWidget.dart';
import '../elements/ItemsCarouselWidget.dart';

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
    _con.refreshRestaurant();
    selectedCategories = ['0'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pushNamed('/Details',
              arguments: RouteArgument(
                  id: '0', param: _con.restaurant.id, heroTag: 'menu_tab')),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   leading: Icon(
            //     Icons.bookmark,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Text(
            //     S.of(context).featured_foods,
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   subtitle: Text(
            //     S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
            //     maxLines: 2,
            //     style: Theme.of(context).textTheme.caption,
            //   ),
            // ),
            // FoodsCarouselWidget(heroTag: 'menu_trending_food', foodsList: _con.trendingFoods),
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
                ? SizedBox(height: 90)
                : Container(
                    height: 60,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_con.categories.length, (index) {
                        var _category = _con.categories.elementAt(index);
                        var _selected =
                            this.selectedCategories.contains(_category.id);
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: RawChip(
                            elevation: 0,
                            label: Text(_category.name),
                            labelStyle: _selected
                                ? Theme.of(context).textTheme.bodyText2.merge(
                                    TextStyle(
                                        color: Theme.of(context).primaryColor))
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
            Stack(alignment: Alignment.centerRight, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onChanged: (text) {
                    setState(()  {
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
            ]),
            _con.selectedItems.isEmpty
                ? /*CircularLoadingWidget(height: 250)*/
                Center(
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
                      return ItemWidget(
                        heroTag: 'menu_list',
                        item: _con.selectedItems.elementAt(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
